{
  pkgs,
  vimUtils,
  ...
}:
vimUtils.buildVimPlugin rec {
  pname = "blink-cmp-luasnip-choice";
  version = "git";
  src = pkgs.fetchFromGitHub {
    # owner = "becknik";
    owner = "antinomie8";
    repo = pname;
    rev = "master";
    hash = "sha256-JfsLabol5+M2wl3m94CKOnCRRnppRbW2J7bCaETnmnI=";
  };
}
