{ lib, stdenv, rustPlatform, fetchFromGitHub, perl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FCELPt7aBKD+mf5w9HuJqKPw64qBLgdbLIfGZEB19OI=";
  };

  cargoSha256 = "sha256-+dy9PcA27NrL448BQAGUg1UB0b6QhPG1kk8UzV3NOBQ=";

  nativeBuildInputs = [ perl ];

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
