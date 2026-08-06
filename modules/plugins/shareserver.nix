{
  flake.modules.nixvim.core = {
    lib,
    pkgs,
    ...
  }:
    lib.nixvim.plugins.mkNeovimPlugin {
      name = "sharedserver";
      package = ["sharedserver-nvim"];
      maintainers = [];
      extraPackages = [pkgs.sharedserver];
    };
}
