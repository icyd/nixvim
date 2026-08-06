{
  flake.modules.nixvim.sshfs = {pkgs, ...}: {
    plugins.sshfs-nvim.enable = pkgs.stdenv.isLinux;
  };
}
