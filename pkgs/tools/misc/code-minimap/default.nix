{ stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "code-minimap";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "03azqy4i15kfpd0gzjaw2di9xva4xdf95yb65b93z3y9y5wy4krc";
  };

  cargoSha256 = "1npzy851n1agx2xh7hnypl96503pdh3zj89msb5cwzd9yz70binx";

  meta = with stdenv.lib; {
    description = "A high performance code minimap render";
    homepage = "https://github.com/wfxr/code-minimap";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ bsima ];
  };
}
