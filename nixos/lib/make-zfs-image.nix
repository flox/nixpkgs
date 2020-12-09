{ lib
, pkgs
, # The NixOS configuration to be installed onto the disk image.
  config

, # The size of the disk, in megabytes.
  diskSize ? 2048

, # size of the boot partition, is only used if partitionTableType is
  # either "efi" or "hybrid"
  bootSize ? 1024

, # The name of the ZFS pool
  poolName ? "tank"

, # zpool properties
  poolProperties ? {
    autoexpand = "on";
  }
, # pool-wide filesystem properties
  filesystemProperties ? {
    acltype = "posixacl";
    atime = "off";
    compression = "on";
    mountpoint = "legacy";
    xattr = "sa";
  }

, # datasets, with per-attribute options:
  # mount: (optional) mount point in the VM
  # properties: (optional) ZFS properties on the dataset, like filesystemProperties
  # Note: datasets will be created from shorter to longer names as a simple topo-sort
  datasets ? {
    "system/root".mount = "/";
    "system/var".mount = "/var";
    "local/nix".mount = "/nix";
    "user/home".mount = "/home";
  }

, # The files and directories to be placed in the target file system.
  # This is a list of attribute sets {source, target} where `source'
  # is the file system object (regular file or directory) to be
  # grafted in the file system at path `target'.
  contents ? []

, # The initial NixOS configuration file to be copied to
  # /etc/nixos/configuration.nix. This configuration will be embedded
  # inside a configuration which includes the described ZFS fileSystems.
  configFile ? null

, # Shell code executed after the VM has finished.
  postVM ? ""

, name ? "nixos-disk-image"

, # Disk image format, one of qcow2, qcow2-compressed, vdi, vpc, raw.
  format ? "raw"

, # Include a copy of Nixpkgs in the disk image
  includeChannel ? true
}:
let
  formatOpt = if format == "qcow2-compressed" then "qcow2" else format;

  compress = lib.optionalString (format == "qcow2-compressed") "-c";

  filename = "nixos." + {
    qcow2 = "qcow2";
    vdi = "vdi";
    vpc = "vhd";
    raw = "img";
  }.${formatOpt} or formatOpt;

  # FIXME: merge with channel.nix / make-channel.nix.
  channelSources =
    let
      nixpkgs = lib.cleanSource pkgs.path;
    in
      pkgs.runCommand "nixos-${config.system.nixos.version}" {} ''
        mkdir -p $out
        cp -prd ${nixpkgs.outPath} $out/nixos
        chmod -R u+w $out/nixos
        if [ ! -e $out/nixos/nixpkgs ]; then
          ln -s . $out/nixos/nixpkgs
        fi
        rm -rf $out/nixos/.git
        echo -n ${config.system.nixos.versionSuffix} > $out/nixos/.version-suffix
      '';

  closureInfo = pkgs.closureInfo {
    rootPaths = [ config.system.build.toplevel ]
    ++ (lib.optional includeChannel channelSources);
  };

  modulesTree = pkgs.aggregateModules
    (with config.boot.kernelPackages; [ kernel zfs ]);

  tools = lib.makeBinPath (
    with pkgs; [
      config.system.build.nixos-enter
      config.system.build.nixos-install
      dosfstools
      e2fsprogs
      nix
      parted
      utillinux
      zfs
    ]
  );

  stringifyProperties = prefix: properties: lib.concatStringsSep " \\\n" (
    lib.mapAttrsToList
      (
        property: value: "${prefix} ${lib.escapeShellArg property}=${lib.escapeShellArg value}"
      )
      properties
  );

  createDatasets =
    let
      datasetlist = lib.mapAttrsToList lib.nameValuePair datasets;
      sorted = lib.sort (left: right: (lib.stringLength left.name) < (lib.stringLength right.name)) datasetlist;
      cmd = { name, value }:
        let
          properties = stringifyProperties "-o" (value.properties or {});
        in
          "zfs create -p ${properties} ${poolName}/${name}";
    in
      lib.concatMapStringsSep "\n" cmd sorted;

  mountDatasets =
    let
      datasetlist = lib.mapAttrsToList lib.nameValuePair datasets;
      mounts = lib.filter ({ value, ... }: value ? "mount") datasetlist;
      sorted = lib.sort (left: right: (lib.stringLength left.value.mount) < (lib.stringLength right.value.mount)) datasetlist;
      cmd = { name, value }:
        ''
          mkdir -p /mnt/${lib.escapeShellArg value.mount}
          mount -t zfs ${poolName}/${name} /mnt/${lib.escapeShellArg value.mount}
        '';
    in
      lib.concatMapStringsSep "\n" cmd sorted;

  unmountDatasets =
    let
      datasetlist = lib.mapAttrsToList lib.nameValuePair datasets;
      mounts = lib.filter ({ value, ... }: value ? "mount") datasetlist;
      sorted = lib.sort (left: right: (lib.stringLength left.value.mount) > (lib.stringLength right.value.mount)) datasetlist;
      cmd = { name, value }:
        ''
          umount /mnt/${lib.escapeShellArg value.mount}
        '';
    in
      lib.concatMapStringsSep "\n" cmd sorted;


  fileSystemsCfgFile =
    let
      mountable = lib.filterAttrs (_: value: value ? "mount") datasets;
    in
      pkgs.writeText "filesystem-config.nix"
        (
          "builtins.fromJSON ''" + (
            builtins.toJSON {
              fileSystems = lib.mapAttrs'
                (
                  dataset: attrs:
                    {
                      name = attrs.mount;
                      value = {
                        fsType = "zfs";
                        device = "${poolName}/${dataset}";
                      };
                    }
                )
                mountable;
            }
          ) + "''"
        );

  mergedConfig =
    if configFile == null
    then fileSystemsCfgFile
    else
      pkgs.runCommand "configuration.nix" {}
        ''
          (
            echo '{ imports = ['
            printf "(%s)\n" "$(cat ${fileSystemsCfgFile})";
            printf "(%s)\n" "$(cat ${configFile})";
            echo ']; }'
          ) > $out
        '';

  image = (
    pkgs.vmTools.override {
      rootModules =
        [ "zfs" "9p" "9pnet_virtio" "virtio_pci" "virtio_blk" "rtc_cmos" ];
      kernel = modulesTree;
    }
  ).runInLinuxVM (
    pkgs.runCommand name
      {
        preVM = ''
          PATH=$PATH:${pkgs.qemu_kvm}/bin
          mkdir $out
          diskImage=nixos.raw
          qemu-img create -f raw $diskImage ${toString diskSize}M
        '';

        postVM = ''
          ${if formatOpt == "raw" then ''
          mv $diskImage $out/${filename}
        '' else ''
          ${pkgs.qemu}/bin/qemu-img convert -f raw -O ${formatOpt} ${compress} $diskImage $out/${filename}
        ''}
          diskImage=$out/${filename}
          ${postVM}
        '';
      } ''
      export PATH=${tools}:$PATH
      set -x

      cp -sv /dev/vda /dev/sda
      cp -sv /dev/vda /dev/xvda

      parted --script /dev/vda -- \
        mklabel gpt \
        mkpart no-fs 1MB 2MB \
        align-check optimal 1 \
        set 1 bios_grub on \
        mkpart ESP fat32 8MB ${toString bootSize}MB \
        align-check optimal 2 \
        set 2 boot on \
        mkpart primary ${toString bootSize}MB -1 \
        align-check optimal 3 \
        print

      zpool create \
        ${stringifyProperties "  -o" poolProperties} \
        ${stringifyProperties "  -O" filesystemProperties} \
        ${poolName} /dev/vda3

      ${createDatasets}
      ${mountDatasets}

      mkdir -p /mnt/boot
      mkfs.vfat /dev/vda2 -n ESP
      mount -t vfat /dev/vda2 /mnt/boot

      mount

      # Install a configuration.nix
      mkdir -p /mnt/etc/nixos
      # `cat` so it is mutable on the fs
      cat ${mergedConfig} > /mnt/etc/nixos/configuration.nix

      export NIX_STATE_DIR=$TMPDIR/state
      nix-store --load-db < ${closureInfo}/registration

      echo copying toplevel
      time nix copy --no-check-sigs --to 'local?root=/mnt/' ${config.system.build.toplevel}

      ${lib.optionalString includeChannel ''
        echo copying channels
        time nix copy --no-check-sigs --to 'local?root=/mnt/' ${channelSources}
      ''}

      echo installing bootloader
      time nixos-install --root /mnt --no-root-passwd \
        --system ${config.system.build.toplevel} \
        --substituters " " ${lib.optionalString includeChannel "--channel ${channelSources}"}

      df -h
      umount /mnt/boot
      ${unmountDatasets}
      zpool export ${poolName}
    ''
  );
in
image
