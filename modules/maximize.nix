{
  flake.modules.nixvim.maximize = {
    config,
    pkgs,
    ...
  }: let
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
