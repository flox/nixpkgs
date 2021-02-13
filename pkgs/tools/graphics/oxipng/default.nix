{ stdenv, fetchCrate, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "4.0.2";
  pname = "oxipng";

  src = fetchCrate {
    inherit version pname;
    sha256 = "0m36af9w1l6pc71fjbgyzcsszizwayvcv5d750zz2bnj23c77m69";
  };

  cargoSha256 = "0hzmv0p6py10s7n2kk70i53x3di4zqznrhj0gzs005b34mwr63yx";

  doCheck = !stdenv.isAarch64 && !stdenv.isDarwin;

  meta = with stdenv.lib; {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "A multithreaded lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
