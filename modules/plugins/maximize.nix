{
  flake.modules.nixvim.core = {lib, ...}:
    lib.nixvim.plugins.mkNeovimPlugin rec {
      name = "maximize-nvim";
      package = ["local" name];
      maintainers = [];
    };
}
