{ stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, curl, darwin, perl }:

rustPlatform.buildRustPackage rec {
  pname = "wrangler";
  version = "1.12.3";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h9020yf5jsbilzn94h7qyxw9qnz3vw43g8a2415wvjqq6ihzfvm";
  };

  cargoSha256 = "0yvdlr1z0yzpxa85kg3zpzs3xb519pbkm0ys9zpxk6fzypvbbs46";

  nativeBuildInputs = [ perl ] ++ stdenv.lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [
      curl
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.CoreFoundation
    ];

  # tries to use "/homeless-shelter" and fails
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A CLI tool designed for folks who are interested in using Cloudflare Workers";
    homepage = "https://github.com/cloudflare/wrangler";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
