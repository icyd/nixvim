{
  flake.modules.nixvim.trouble = {config, ...}: let
    inherit (config.utils.mkKey) mkKeyMapIf keymapUnlazy keymap2Lazy wKeyObjMapIf;
    cfg = config.plugins.trouble;
    keymaps = mkKeyMapIf cfg.enable [
      {
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics toggle";
      }
      {
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options.desc = "Buffer Diagnostics toggle";
      }
      {
        key = "<leader>xs";
        action = "<cmd>Trouble symbols toggle focus=false<cr>";
        options.desc = "Symbols toggle";
      }
      {
        key = "<leader>xl";
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
        options.desc = "LSP Definitions / references / ... toggle";
      }
      {
        key = "<leader>xL";
        action = "<cmd>Trouble loclist toggle<cr>";
        options.desc = "Location List toggle";
      }
      {
        key = "<leader>xQ";
        action = "<cmd>Trouble qflist toggle<cr>";
        options.desc = "Quickfix List toggle";
      }
      {
        action.__raw = ''
          function()
            require("trouble").first({ skip_groups = true, jump = true})
          end
        '';
        key = "[X";
        options.desc = "Trouble go to first";
      }
      {
        action.__raw = ''
          function()
            require("trouble").previous({ skip_groups = true, jump = true})
          end
        '';
        key = "[x";
        options.desc = "Trouble go to previous";
      }
      {
        action.__raw = ''
          function()
            require("trouble").next({ skip_groups = true, jump = true})
          end
        '';
        key = "]x";
        options.desc = "Trouble go to next";
      }
      {
        action.__raw = ''
          function()
            require("trouble").last({ skip_groups = true, jump = true})
          end
        '';
        key = "]X";
        options.desc = "Trouble go to last";
      }
    ];
  in {
    plugins = {
      trouble = {
        enable = true;
        lazyLoad.settings = {
          cmd = "Trouble";
          keys = keymap2Lazy keymaps;
        };
        settings.auto_close = true;
      };
      web-devicons.enable = true;
    };
    keymaps = keymapUnlazy keymaps;
    utils.wKeyList = wKeyObjMapIf cfg.enable [
      ["<leader>x" "" "Trouble"]
    ];
  };
}
