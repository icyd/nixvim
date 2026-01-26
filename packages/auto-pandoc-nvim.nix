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
    rev = "1e28cbb1de644be466a36a009c6fd3b7950cacf7";
    hash = "sha256-VZV9xjq6S9M9eSCDE2nV8fv6kJsC4otYJ7ZGuZwpaXw=";
  };
}
