{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "pastel";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "00xxrssa3gbr5w2jsqlf632jlzc0lc2rpybnbv618ndy5lxidnw0";
  };

  cargoSha256 = "0z1k2ipwgkza7mgcdc6ifzx60nhzjdv8kzwf62gvds4cvdydr6cc";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A command-line tool to generate, analyze, convert and manipulate colors";
    homepage = "https://github.com/sharkdp/pastel";
    changelog = "https://github.com/sharkdp/pastel/releases/tag/v${version}";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ davidtwco ];
  };
}
