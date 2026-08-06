{
  flake.modules.nixvim.core = {lib, ...}:
    lib.nixvim.plugins.mkNeovimPlugin rec {
      name = "codecompanion-spinners";
      package = ["local" name];
      maintainers = [];
      callSetup = false;
    };
}
