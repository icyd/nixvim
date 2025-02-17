{
  lib,
  config,
  ...
}: let
  inherit (config.my.mkKey) keymap2mkKeyMap keymapUnlazy keymap2Lazy wKeyObj;
  cfg = config.plugins.trouble;
  keymaps = keymap2mkKeyMap (lib.optionals cfg.enable [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble preview_split toggle<cr>";
      options = {
        desc = "Diagnostics toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble preview_split toggle filter.buf=0<cr>";
      options = {
        desc = "Buffer Diagnostics toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xs";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options = {
        desc = "Symbols toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      options = {
        desc = "LSP Definitions / references / ... toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options = {
        desc = "Location List toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      options = {
        desc = "Quickfix List toggle";
      };
    }
    {
      action.__raw = ''
        function()
          require("trouble").first({ skip_groups = true, jump = true})
        end
      '';
      key = "[X";
      mode = "n";
      options.desc = "Trouble go to first";
    }
    {
      action.__raw = ''
        function()
          require("trouble").previous({ skip_groups = true, jump = true})
        end
      '';
      key = "[x";
      mode = "n";
      options.desc = "Trouble go to previous";
    }
    {
      action.__raw = ''
        function()
          require("trouble").next({ skip_groups = true, jump = true})
        end
      '';
      key = "]x";
      mode = "n";
      options.desc = "Trouble go to next";
    }
    {
      action.__raw = ''
        function()
          require("trouble").last({ skip_groups = true, jump = true})
        end
      '';
      key = "]X";
      mode = "n";
      options.desc = "Trouble go to last";
    }
  ]);
in {
  plugins = {
    trouble = {
      enable = true;
      lazyLoad.settings = {
        cmd = "Trouble";
        keys = keymap2Lazy keymaps;
      };
    };
    web-devicons.enable = true;
  };
  keymaps = keymapUnlazy keymaps;
  my.wKeyList = lib.optionals cfg.enable [
    (wKeyObj ["<leader>x" "" "Trouble"])
  ];
}
