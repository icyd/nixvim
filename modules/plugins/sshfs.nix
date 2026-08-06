{
  flake.modules.nixvim.core = {
    lib,
    pkgs,
    ...
  }:
    lib.nixvim.plugins.mkNeovimPlugin rec {
      name = "sshfs-nvim";
      moduleName = "sshfs";
      package = ["local" name];
      maintainers = [];
      extraPackages = pkgs.sshfs;
    };
}
