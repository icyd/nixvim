{
  lib,
  config,
  ...
}: let
  cfg = config.plugins.compiler;
  inherit (config.my.mkKey) mkKeyMap keymapUnlazy keymap2Lazy wKeyObj;
  keymaps = builtins.map mkKeyMap (lib.optionals cfg.enable [
    {
      action = "<cmd>CompilerOpen<CR>";
      key = "<leader>Ro";
      mode = "n";
      options.desc = "Compiler Open";
    }
    {
      action = "<cmd>CompilerRedo<CR>";
      key = "<leader>Rr";
      mode = "n";
      options.desc = "Compiler Redo";
    }
    {
      action = "<cmd>CompilerStop<CR>";
      key = "<leader>Rs";
      mode = "n";
      options.desc = "Compiler Stop";
    }
    {
      action = "<cmd>CompilerToggleResults<CR>";
      key = "<leader>Rt";
      mode = "n";
      options.desc = "Compiler Toggle Results";
    }
  ]);
in {
  plugins = {
    compiler = {
      enable = true;
      lazyLoad.settings = {
        before.__raw = ''
          function()
            require("lz.n").trigger_load("overseer.nvim")
          end
        '';
        cmd = [
          "CompilerOpen"
          "CompilerRedo"
          "CompilerStop"
          "CompilerToggleResults"
        ];
        keys = keymap2Lazy keymaps;
      };
    };
  };
  keymaps = keymapUnlazy keymaps;
  my.wKeyList = lib.optionals cfg.enable [
    (wKeyObj ["<leader>R" "" "Compiler"])
  ];
}
