{ stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "angle-grinder";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "rcoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m5yj9412kjlnqi1nwh44i627ip0kqcbhvwgh87gl5vgd2a0m091";
  };

  cargoSha256 = "1d82yykazcnwqc83sab9qhm1nkwdicq561rlj3h7w2h6wb3ypiiq";

  meta = with stdenv.lib; {
    description = "Slice and dice logs on the command line";
    homepage = "https://github.com/rcoh/angle-grinder";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
