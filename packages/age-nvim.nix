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
    rev = "f1793e14123a7c5374a3744aacab9c283014fa1d";
    hash = "sha256-NcO7ebDJfjdh3jv+yzyxkOLmnV2mgzy++ltkDJ2NY7s=";
  };
}
