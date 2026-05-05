{
  pkgs,
  vimUtils,
  ...
}:
vimUtils.buildVimPlugin rec {
  pname = "blink-cmp-luasnip-choice";
  version = "git";
  src = pkgs.fetchFromGitHub {
    owner = "becknik";
    repo = pname;
    rev = "master";
    hash = "sha256-rVuqTDbeQHI8chRd9KO8bM7Fra27NtqUIKU/+1/r+gk=";
  };
}
