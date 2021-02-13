{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g9zr2afi103cwv6ikpmmyh5v055dh47l3wj9a1kbxgms0953iwh";
  };

  cargoSha256 = "1pv0l22mv41zpahx3znnac0grz851jqjj6x34x62nrcnn3hwgyvs";

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
