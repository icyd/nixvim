{
  flake.modules.nixvim.oil = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap keymapUnlazy keymap2Lazy;
    keymaps = builtins.map mkKeyMap (lib.optionals config.plugins.oil.enable [
      {
        action = "<cmd>Oil<CR>";
        key = "<leader>o";
        options.desc = "Open Oil file browser";
      }
    ]);
  in {
    keymaps = keymapUnlazy keymaps;
    plugins.oil = {
      enable = true;
      lazyLoad.settings = {
        cmd = "Oil";
        keys = keymap2Lazy keymaps;
      };
    };
  };
}
