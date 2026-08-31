{
  flake.modules.nixvim.core = {lib, ...}:
    lib.nixvim.plugins.mkNeovimPlugin rec {
      name = "codecompanion-ui";
      package = ["local" name];
      maintainers = [];
    };
}
