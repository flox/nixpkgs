{ stdenv
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-wipe";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "mihai-dinculescu";
    repo = "cargo-wipe";
    rev = "v${version}";
    sha256 = "1kwkifdp98zsinh7xcsz2va252wxbw73xlrv0r7h3m0bn51d52vw";
  };

  cargoSha256 = "1wnmpj9y4j7yc7gwah6a1a426cy08564h5mcf0lh74y7nkda8z11";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = ''Cargo subcommand "wipe": recursively finds and optionally wipes all "target" or "node_modules" folders'';
    homepage = "https://github.com/mihai-dinculescu/cargo-wipe";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ otavio ];
  };
}
