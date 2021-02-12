{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-02-15";
    version = "unstable-${rev}";
    sha256 = "sha256-4Dgj2RQDe2FoOSXjL7oaHg8WlYX1vnc66LzzbXvTmjM=";
    cargoSha256 = "sha256-uKylajBJv4mXW0fpX1a8hvghA3/AviTbf4EPSCbGLCw=";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
