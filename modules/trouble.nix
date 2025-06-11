{
  flake.modules.nixvim.trouble = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap keymapUnlazy keymap2Lazy wKeyObj;
    inherit (lib.nixvim.utils) mkRaw;
    cfg = config.plugins.trouble;
    keymaps = builtins.map mkKeyMap (lib.optionals cfg.enable [
      {
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options = {
          desc = "Diagnostics toggle";
        };
      }
      {
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options = {
          desc = "Buffer Diagnostics toggle";
        };
      }
      {
        key = "<leader>xs";
        action = "<cmd>Trouble symbols toggle focus=false<cr>";
        options = {
          desc = "Symbols toggle";
        };
      }
      {
        key = "<leader>xl";
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
        options = {
          desc = "LSP Definitions / references / ... toggle";
        };
      }
      {
        key = "<leader>xL";
        action = "<cmd>Trouble loclist toggle<cr>";
        options = {
          desc = "Location List toggle";
        };
      }
      {
        key = "<leader>xQ";
        action = "<cmd>Trouble qflist toggle<cr>";
        options = {
          desc = "Quickfix List toggle";
        };
      }
      {
        action = mkRaw ''
          function()
            require("trouble").first({ skip_groups = true, jump = true})
          end
        '';
        key = "[X";
        options.desc = "Trouble go to first";
      }
      {
        action = mkRaw ''
          function()
            require("trouble").previous({ skip_groups = true, jump = true})
          end
        '';
        key = "[x";
        options.desc = "Trouble go to previous";
      }
      {
        action = mkRaw ''
          function()
            require("trouble").next({ skip_groups = true, jump = true})
          end
        '';
        key = "]x";
        options.desc = "Trouble go to next";
      }
      {
        action = mkRaw ''
          function()
            require("trouble").last({ skip_groups = true, jump = true})
          end
        '';
        key = "]X";
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
    utils.wKeyList = lib.optionals cfg.enable [
      (wKeyObj ["<leader>x" "" "Trouble"])
    ];
  };
}
