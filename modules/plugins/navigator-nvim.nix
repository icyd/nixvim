{
  flake.modules.nixvim.core = {lib, ...}:
    lib.nixvim.plugins.mkNeovimPlugin {
      name = "navigator-nvim";
      moduleName = "Navigator";
      package = "Navigator-nvim";
      maintainers = [];
    };
}
