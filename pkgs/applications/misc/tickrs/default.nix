{ stdenv, rustPlatform, fetchFromGitHub, perl }:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "v${version}";
    sha256 = "159smcjrf5193yijfpvy1g9b1gin72xwbjghfyrrphwscwhb215z";
  };

  cargoSha256 = "0mbm3c1944dmlrw0vaxmarqfwmm2zm7q2p8i637m1wdcp23zsrya";

  nativeBuildInputs = [ perl ];

  meta = with stdenv.lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
