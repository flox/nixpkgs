{ stdenv, fetchFromGitHub, rustPlatform, Security, openssl, pkgconfig, libiconv, curl }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ashleygwilliams";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "0rq0anz0cawrgsinqyjh8wb3dgha09wx3ydrd3m9nfxs5dd3ij3k";
  };

  cargoSha256 = "00v1qx2yan1w6gvqzay4a169bfa9skkmkj94zn41b66dfz1gvy0y";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl  ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  preCheck = ''
    export HOME=$(mktemp -d) USER=nixbld
    git config --global user.name Nixbld
    git config --global user.email nixbld@localhost.localnet
  '';

  meta = with stdenv.lib; {
    description = "cargo, make me a project";
    homepage = "https://github.com/ashleygwilliams/cargo-generate";
    license = licenses.asl20;
    maintainers = [ maintainers.turbomack ];
  };
}
