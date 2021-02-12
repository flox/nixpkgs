{ fetchFromGitHub, rustPlatform, lib }:

with rustPlatform;

buildRustPackage rec {
  pname = "tarssh";
  version = "0.5.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Freaky";
    repo = pname;
    sha256 = "1waxfbw9lqbqv8igb291pjqg22324lzv4p7fsdfrkvxf95jd2i03";
  };

  cargoSha256 = "16474kg5zd2lqy75bf4px5zahvsaalbyps3yg7861n0q28bfx8a8";

  meta = with lib; {
    description = "A simple SSH tarpit inspired by endlessh";
    homepage = "https://github.com/Freaky/tarssh";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ sohalt ];
    platforms = platforms.unix ;
  };
}
