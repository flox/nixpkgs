{ lib
, rustPlatform
, fetchFromGitHub
, cryptsetup
, pkg-config
, clang
, llvmPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "fido2luks";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "shimunn";
    repo = pname;
    rev = version;
    sha256 = "1v5gxcz4zbc673i5kbsnjq8bikf7jdbn3wjfz1wppjrgwnkgvsh9";
  };

  buildInputs = [ cryptsetup ];
  nativeBuildInputs = [ pkg-config clang ];

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang}/lib"
  '';

  cargoSha256 = "0v6xm22r6gp09wl65qza1nzkygaldliy0j4qfwm4pj0all8immh9";

  meta = with lib; {
    description = "Decrypt your LUKS partition using a FIDO2 compatible authenticator";
    homepage = "https://github.com/shimunn/fido2luks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prusnak mmahut ];
    platforms = platforms.linux;
  };
}
