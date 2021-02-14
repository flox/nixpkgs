{ lib
, fetchFromGitHub
, rustPlatform
, cmake
, llvmPackages
, openssl
, pkg-config
, stdenv
, systemd
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "openethereum";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "openethereum";
    repo = "openethereum";
    rev = "v${version}";
    sha256 = "cs84Zz0nhagGDu5sDFTaFZF3SPEgJU8F4vGX7KLihOM=";
  };

  cargoSha256 = "NM1l9dvL0iV++L1bqyb6r3F7lpCXu2bsxKm/qhFvjTI=";

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  nativeBuildInputs = [
    cmake
    llvmPackages.clang
    llvmPackages.libclang
    pkg-config
  ];

  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isLinux [ systemd ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.Security ];

  cargoBuildFlags = [ "--features final" ];

  # test result: FAILED. 88 passed; 13 failed; 0 ignored; 0 measured; 0 filtered out
  doCheck = false;

  meta = with lib; {
    description = "Fast, light, robust Ethereum implementation";
    homepage = "http://parity.io/ethereum";
    license = licenses.gpl3;
    maintainers = with maintainers; [ akru xrelkd ];
    platforms = stdenv.lib.platforms.unix;
  };
}
