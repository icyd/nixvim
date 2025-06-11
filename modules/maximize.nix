{
  flake.modules.nixvim.maximize = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap keymapUnlazy keymap2Lazy;
    inherit (lib.nixvim.utils) mkRaw;
    keymaps = builtins.map mkKeyMap [
      {
        action = mkRaw ''
          function()
            require("maximize").toggle()
          end
        '';
        key = "<leader>z";
        options.desc = "Maximize windows";
      }
    ];
  in {
    extraPlugins = with pkgs.local; [
      maximize-nvim
    ];
    keymaps = keymapUnlazy keymaps;
    plugins.lz-n.plugins = [
      {
        __unkeyed-1 = "maximize-nvim";
        enabled = true;
        after = ''
          function()
            require("maximize").setup({})
          end
        '';
        keys = keymap2Lazy keymaps;
      }
    ];
  };
}
