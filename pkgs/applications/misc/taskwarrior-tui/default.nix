{ stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "1348ypjphm5f46civbrcxbbahwwl2j47z1hg8ndq1cg2bh5wb8kg";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoSha256 = "1s269wy65w4s28g571i2ka33kk91az8ignxhr056j7fmnhxxnm6x";

  meta = with stdenv.lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
