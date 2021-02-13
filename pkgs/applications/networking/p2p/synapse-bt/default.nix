{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, CoreServices, Security }:

rustPlatform.buildRustPackage rec {
  pname = "synapse-bt";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "Luminarys";
    repo = "synapse";
    rev = version;
    sha256 = "01npv3zwia5d534zdwisd9xfng507adv4qkljf8z0zm0khqqn71a";
  };

  cargoSha256 = "1qj1145y54i7i3bqif9axd7605gh2bl1kvlpbw7zqhhbvgg46h37";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices Security ];

  cargoBuildFlags = [ "--all" ];

  meta = with stdenv.lib; {
    description = "Flexible and fast BitTorrent daemon";
    homepage = "https://synapse-bt.org/";
    license = licenses.isc;
    maintainers = with maintainers; [ dywedir ];
  };
}
