{
  pkgs,
  vimUtils,
  ...
}:
vimUtils.buildVimPlugin {
  name = "auto-pandoc-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "jghauser";
    repo = "/auto-pandoc.nvim";
    rev = "11d007dcab1dd4587bfca175e18b6017ff4ad1dc";
    hash = "sha256-VZV9xjq6S9M9eSCDE2nV8fv6kJsC4otYJ7ZGuZwpaXw=";
  };
}
