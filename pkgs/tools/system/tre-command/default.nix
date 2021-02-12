{ rustPlatform, fetchFromGitHub, lib, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "tre-command";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "dduan";
    repo = "tre";
    rev = "v${version}";
    sha256 = "10c8mpqzpw7m3vrm2vl2rx678z3c37hxpqyh3fn83dlh9f4f0j87";
  };

  cargoSha256 = "0yn3lkvppabcizcif1mkan0ccgg8xp71f4ddp8zlhfwsvmdafvrs";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    installManPage manual/tre.1
  '';

  meta = with lib; {
    description = "Tree command, improved";
    homepage = "https://github.com/dduan/tre";
    license = licenses.mit;
    maintainers = [ maintainers.dduan ];
  };
}
