{
  flake.modules.nixvim.core = {
    lib,
    pkgs,
    ...
  }:
    lib.nixvim.plugins.mkNeovimPlugin {
      name = "rustowl";
      package = ["rustowl-nvim"];
      maintainers = [];
      extraPackages = [pkgs.rustowl];
    };
}
