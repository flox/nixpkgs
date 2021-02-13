{ stdenv, rustPlatform, fetchurl, pkgconfig, ncurses, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "asuka";
  version = "0.8.1";

  src = fetchurl {
    url = "https://git.sr.ht/~julienxx/${pname}/archive/${version}.tar.gz";
    sha256 = "07i80qmdpwfdgwrk1gzs10wln91v23qjrsk0x134xf5mjnakxc06";
  };

  cargoSha256 = "1h2gpnflzk7qc1d3nry3831ygrjcn54p6bqhs8r8w2iilp6ny60z";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ ncurses openssl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "Gemini Project client written in Rust with NCurses";
    homepage = "https://git.sr.ht/~julienxx/asuka";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
