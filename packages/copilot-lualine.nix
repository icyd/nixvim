{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin rec {
  pname = "copilot-lualine";
  version = "git";
  src = fetchFromGitHub {
    owner = "AndreM222";
    repo = pname;
    rev = "222e90bd8dcdf16ca1efc4e784416afb5f011c31";
    hash = "sha256-HYNqPdwatrNTNUGo6I2SzmNxSI4iqX+Ls7GHQcU8+Fk=";
  };
}
