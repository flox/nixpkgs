{ lib, stdenv
, nixosTests
, fetchFromGitHub
, rustPlatform
, asciidoctor
, installShellFiles
, pkg-config
, Security
, withPCRE2 ? true
, pcre2 ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "12.1.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = pname;
    rev = version;
    sha256 = "1hqps7l5qrjh9f914r5i6kmcz6f1yb951nv4lby0cjnp5l253kps";
  };

  cargoSha256 = "0v2i9b8n6y3pc4vw379kvrb6j9rk35wrjcwlrwybkrdxd82gfkib";

  cargoBuildFlags = lib.optional withPCRE2 "--features pcre2";

  nativeBuildInputs = [ asciidoctor installShellFiles ]
    ++ lib.optional withPCRE2 pkg-config;
  buildInputs = (lib.optional withPCRE2 pcre2)
    ++ (lib.optional stdenv.isDarwin Security);

  preFixup = ''
    installManPage $releaseDir/build/ripgrep-*/out/rg.1

    installShellCompletion $releaseDir/build/ripgrep-*/out/rg.{bash,fish}
    installShellCompletion --zsh complete/_rg
  '';

  passthru.tests = { inherit (nixosTests) ripgrep; };

  meta = with lib; {
    description = "A utility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = "https://github.com/BurntSushi/ripgrep";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ tailhook globin ma27 zowoq ];
  };
}
