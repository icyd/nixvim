{
  flake.modules.nixvim.core = {lib, ...}:
    lib.nixvim.plugins.mkNeovimPlugin rec {
      name = "codecompanion-picker";
      moduleName = "code-companion-picker";
      package = ["local" name];
      maintainers = [];
    };
}
