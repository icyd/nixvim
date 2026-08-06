{
  flake.modules.nixvim.core = {lib, ...}:
    lib.nixvim.plugins.mkNeovimPlugin rec {
      name = "nvim-rooter";
      package = ["local" name];
      maintainers = [];
    };
}
