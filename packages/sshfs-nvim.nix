{
  pkgs,
  vimUtils,
  ...
}:
vimUtils.buildVimPlugin {
  pname = "sshfs-nvim";
  version = "git";
  src = pkgs.fetchFromGitHub {
    owner = "uhs-robert";
    repo = "/sshfs.nvim";
    rev = "57f586251d788dae38fd12998b9a208f7d54c1ef";
    hash = "sha256-Vcdjd0WbeSFIeRyCxzHNdFwC33l3hKAvZ3kKCDTDHco=";
  };
}
