{ stdenv
, fetchFromGitHub
, rustPlatform
, perl
, pkg-config
, Security
, curl
, libiconv
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-crev";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "crev-dev";
    repo = "cargo-crev";
    rev = "v${version}";
    sha256 = "1ccwa44hpmpd57ff6w02rvrs63wxwmgls2i1rn285rxypmbysrp0";
  };

  cargoSha256 = "1f5k16ggia1wzryfv1cch857dwifjx0xildynln2ps5jcxarlyvc";

  nativeBuildInputs = [ perl pkg-config ];

  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with stdenv.lib; {
    description = "A cryptographically verifiable code review system for the cargo (Rust) package manager";
    homepage = "https://github.com/crev-dev/cargo-crev";
    license = with licenses; [ asl20 mit mpl20 ];
    maintainers = with maintainers; [ b4dm4n ];
  };
}
