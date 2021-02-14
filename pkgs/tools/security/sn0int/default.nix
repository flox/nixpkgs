{ lib, fetchFromGitHub, rustPlatform, libsodium, libseccomp, sqlite, pkgconfig
}:

rustPlatform.buildRustPackage rec {
  pname = "sn0int";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "10f1wblczxlww09f4dl8i9zzgpr14jj7s329wkvm7lafmwx3qrn5";
  };

  cargoSha256 = "1h2075skj2hcqya714frf9jfva6zy86q9rlz8g0lcvpr70b43bny";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libsodium libseccomp sqlite ];

  # One of the dependencies (chrootable-https) tries to read "/etc/resolv.conf"
  # in "checkPhase", hence fails in sandbox of "nix".
  doCheck = false;

  meta = with lib; {
    description = "Semi-automatic OSINT framework and package manager";
    homepage = "https://github.com/kpcyrd/sn0int";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
