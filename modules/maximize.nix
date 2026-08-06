{
  flake.modules.nixvim.maximize = {config, ...}: let
    inherit (config.utils.mkKey) mkKeyMap keymapUnlazy keymap2Lazy;
    keymaps = mkKeyMap [
      {
        action.__raw = ''
          function()
            require("maximize").toggle()
          end
        '';
        key = "<leader>az";
        options.desc = "Maximize windows";
      }
    ];
  in {
    keymaps = keymapUnlazy keymaps;
    plugins.maximize-nvim = {
      enable = true;
      lazyLoad.settings.keys = keymap2Lazy keymaps;
    };
  };
}
