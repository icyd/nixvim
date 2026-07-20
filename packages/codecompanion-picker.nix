{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin rec {
  pname = "code-companion-picker";
  version = "git";
  src = fetchFromGitHub {
    owner = "3ZsForInsomnia";
    repo = pname;
    rev = "70fad4e271bcfc879c61cc2ab4b20b5f55f83764";
    hash = "sha256-HL4M72D10VQRa6N5ftu6Epaa99yG2ssK9NeEzVjaECc=";
  };
}
