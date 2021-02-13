{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-01-04";
    version = "unstable-${rev}";
    sha256 = "sha256-VRnmx5SfmdMIVQjixWBSaMioqFUlo9VOIKsPvC5t3t4=";
    cargoSha256 = "sha256-BE5XKFrl12M+Dgqwn+JTspKn/ja3DVSyDLfcFd80vFk=";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
