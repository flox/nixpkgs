{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "swapview";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "lilydjwg";
    repo = "swapview";
    rev = "v${version}";
    sha256 = "0339biydk997j5r72vzp7djwkscsz89xr3936nshv23fmxjh2rzj";
  };

  cargoSha256 = "11inh4gwg8q6724yfrgdz1mxq7s674gydsgrwbdwagl8azh3rhcy";

  meta = with lib; {
    description = "A simple program to view processes' swap usage on Linux";
    homepage = "https://github.com/lilydjwg/swapview";
    platforms = platforms.linux;
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ oxalica ];
  };
}
