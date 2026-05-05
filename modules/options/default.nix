{
  flake.modules.nixvim.core = {lib, ...}: {
    options = {
      disabledPlugins = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "gzip"
          "matchit"
          "matchparen"
          "netrwPlugin"
          "rplugin"
          "tarPlugin"
          "tohtml"
          "tutor"
          "zipPlugin"
        ];
        description = "Built-in Neovim plugins to disable for faster startup";
      };
      optimizationEnable =
        lib.mkEnableOption "Enable performance optimizations"
        // {
          default = true;
        };
      userdata = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "Real Name";
        };
        email = lib.mkOption {
          type = lib.types.str;
          default = "mail@example.com";
        };
      };
    };
  };
}
