{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "6.5.1";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5S9mKmnrycrL7DFq8duWVbzEHQfiXAXQYcc3bdiVu1k=";
  };

  cargoSha256 = "1kwpydi0n7pa8r4lmv00jaj52p4hxqgr3l0rysgjgcmmlwjrw1rd";

  buildInputs = lib.optional stdenv.isDarwin Foundation;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ Br1ght0ne hugoreeves SuperSandro2000 ];
  };
}
