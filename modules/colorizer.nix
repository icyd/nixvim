{
  flake.modules.nixvim.colorizer = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap keymapUnlazy keymap2Lazy;
    inherit (lib.nixvim.utils) mkRaw;
    keymaps = builtins.map mkKeyMap (lib.optionals config.plugins.colorizer.enable [
      {
        action = mkRaw ''
          function()
            vim.g.colorizing_enabled = not vim.g.colorizing_enabled
            vim.cmd('ColorizerToggle')
            vim.notify(string.format("Colorizing %s", bool2str(vim.g.colorizing_enabled), "info"))
          end
        '';
        key = "<leader>uC";
        options = {
          desc = "Colorizer toggle";
          options.silent = true;
        };
      }
    ]);
  in {
    keymaps = keymapUnlazy keymaps;
    plugins.colorizer = {
      enable = true;
      lazyLoad.settings.keys = keymap2Lazy keymaps;
      settings.user_default_options = {
        mode = "virtualtext";
        names = false;
      };
    };
  };
}
