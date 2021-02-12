{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "6.3.2";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yKNHUH+oLQ99oH3yKYQCGAfX3tOI3ghLzLUpPzU6M0k=";
  };

  cargoSha256 = "sha256-hgTdfvRrA84ss8zBKqep6GL89Ew11O50aHl0WybSvJI=";

  buildInputs = lib.optional stdenv.isDarwin Foundation;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Br1ght0ne hugoreeves ];
  };
}
