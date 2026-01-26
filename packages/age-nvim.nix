{
  pkgs,
  vimUtils,
  ...
}:
vimUtils.buildVimPlugin {
  pname = "age-nvim";
  version = "0.1.0";
  src = pkgs.fetchFromGitHub {
    owner = "KingMichaelPark";
    repo = "/age.nvim";
    rev = "92c058c1b8b0d52840088afb41a2c15f7cd0aeab";
    hash = "sha256-NcO7ebDJfjdh3jv+yzyxkOLmnV2mgzy++ltkDJ2NY7s=";
  };
}
