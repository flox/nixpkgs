{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "173nj6fx2l15shy7s4dngnfqsa10m7qwhi2ia2rr421l7b24ixqq";
  };

  cargoSha256 = "0b10z2gwxl0y65v4v2lx6xx20z17rmgfbvy7bhkklxy5qmqzf6z9";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
