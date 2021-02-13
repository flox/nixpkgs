{ stdenv, lib, rustPlatform, fetchFromGitLab, pkgconfig, file, perl, curl, cmake, openssl, libssh2, libgit2, libzip, Security }:

rustPlatform.buildRustPackage rec {
  pname = "powerline-rs";
  version = "0.2.0";

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "powerline-rs";
    rev = version;

    sha256 = "0rqlxxl58dpfvm2idhi0vzinraf4bgiapmawiih9wxs599fnhm3y";
  };

  cargoSha256 = "0lns6ba1pg12v4v4ql9hjbwvxh9vnff63iq2p7m2dwynjxr5r1kk";

  nativeBuildInputs = [ pkgconfig file perl cmake curl ];
  buildInputs = [ openssl libssh2 libgit2 libzip ] ++ lib.optional stdenv.isDarwin Security;

  COMPLETION_OUT = "out";
  postInstall = ''
    install -Dm 755 "${COMPLETION_OUT}/${pname}.bash" "$out/share/bash-completion/completions/${pname}"
    install -Dm 755 "${COMPLETION_OUT}/${pname}.fish" "$out/share/fish/vendor_completions.d/${pname}"
  '';

  meta = with lib; {
    description = "powerline-shell rewritten in Rust, inspired by powerline-go";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
  };
}
