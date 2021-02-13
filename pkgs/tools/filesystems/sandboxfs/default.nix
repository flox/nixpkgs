{ stdenv
, fetchFromGitHub
, rustPlatform
, fuse
, pkg-config
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "sandboxfs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "sandboxfs-${version}";
    sha256 = "Ia6rq6FN4abnvLXjlQh4Q+8ra5JThKnC86UXC7s9//U=";
  };

  cargoSha256 = "sha256-8VA6CLLBJPyp51i/KZ8eveV/rCJzMM9wNJpWA+vjkUw=";

  # Issue to add Cargo.lock upstream: https://github.com/bazelbuild/sandboxfs/pull/115
  cargoPatches = [ ./Cargo.lock.patch ];

  nativeBuildInputs = [ pkg-config installShellFiles ];

  buildInputs = [ fuse ];

  postInstall = "installManPage man/sandboxfs.1";

  meta = with stdenv.lib; {
    description = "A virtual file system for sandboxing";
    homepage = "https://github.com/bazelbuild/sandboxfs";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ jeremyschlatter ];
  };
}
