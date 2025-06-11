{
  flake.modules.nixvim.project-nvim = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap;
    inherit (lib.nixvim.utils) mkRaw;
    keymaps = builtins.map mkKeyMap (lib.optionals (config.plugins.telescope.enable && config.plugins.project-nvim.enable) [
      {
        action = "<cmd>Telescope projects<CR>";
        key = "<leader>fp";
        options.desc = "Find projects";
      }
    ]);
  in {
    inherit keymaps;
    plugins.project-nvim = {
      enable = true;
      enableTelescope = config.plugins.telescope.enable;
      lazyLoad.settings = {
        event = "DeferredUIEnter";
        before = mkRaw ''
          require("lz.n").trigger_load("telescope")
        '';
      };
      settings = {
        detection_methods = ["pattern" "lsp"];
        scope_chdir = "win";
        show_hidden = true;
      };
    };
  };
}
