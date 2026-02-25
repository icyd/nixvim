{
  pkgs,
  vimUtils,
  lib,
  ...
}:
vimUtils.buildVimPlugin {
  pname = "sshfs-nvim";
  version = "git";
  src = pkgs.fetchFromGitHub {
    owner = "uhs-robert";
    repo = "/sshfs.nvim";
    rev = "2ddf503bb32f0a0d0794aa582714dfeabfa2ac81";
    hash = "sha256-BZdfoPEkeupBQr2BC4KA+QpHD9DIxqI+J9CJPR/ch+Q=";
  };
}
