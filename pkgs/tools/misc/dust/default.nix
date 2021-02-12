{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "du-dust";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "bootandy";
    repo = "dust";
    rev = "v${version}";
    sha256 = "sha256-JwGa1icwV1yqxy90Psd9bzM7VzM7HPA6kONkI3Y745Q=";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -rf $out/src/test_dir3/
    '';
  };

  cargoSha256 = "sha256-fcspjHTh5B8lNnnxQRhe78B8iKQ16VbJXvoMn8eOcxc=";

  doCheck = false;

  meta = with lib; {
    description = "du + rust = dust. Like du but more intuitive";
    homepage = "https://github.com/bootandy/dust";
    license = licenses.asl20;
    maintainers = [ maintainers.infinisil ];
  };
}
