{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "08n2sp0yj7ql5aagxw94dn8bx2jkigs9zlylf5zkg673bh54829x";
  };

  cargoSha256 = "0nyqhvq83ijsvn71dggh2pr39hnrjbvb4mggzl1aszj1k1i6w34v";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
