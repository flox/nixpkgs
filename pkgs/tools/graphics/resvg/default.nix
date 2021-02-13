{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "0iqlg0wmx9y81ncbw4ihd6pr7ddpfsvk35zmhzsq4plwzbxgp0w1";
  };

  cargoSha256 = "1zag3q8zin6i22jvjwxcx63fp5zbk2n8rv9qfm6152vic73qn4hz";

  doCheck = false;

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
