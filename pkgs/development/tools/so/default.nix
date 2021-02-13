{ stdenv, rustPlatform, fetchFromGitHub, openssl, pkg-config, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "so";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "samtay";
    repo = pname;
    rev = "v${version}";
    sha256 = "09zswxxli9f5ayjwmvqhkp1yv2s4f435dcfp4cyia1zddbrh2zck";
  };

  cargoSha256 = "10raq4j27q7aky5nj2jllpr54nf5267vm8lmhq0mqc0f01rh8p3s";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv Security
  ];

  meta = with stdenv.lib; {
    description = "A TUI interface to the StackExchange network";
    homepage = "https://github.com/samtay/so";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
