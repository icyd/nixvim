{
  flake.modules.nixvim.grug-far = {config, ...}: let
    inherit (config.utils.mkKey) mkKeyMapIf keymapUnlazy keymap2Lazy wKeyObjMapIf;
    cfg = config.plugins.grug-far;
    keymaps = mkKeyMapIf cfg.enable [
      {
        action = "<cmd>GrugFar<CR>";
        key = "<leader>rg";
        options.desc = "GrugFar toggle";
      }
      {
        action.__raw = ''
          function()
            require("grug-far").open({
              prefills = {
                search = vim.fn.expand("<cword>"),
                paths = vim.fn.expand("%"),
              }
            })
          end
        '';
        key = "<leader>rw";
        options.desc = "GrugFar rename word in buffer";
      }
      {
        action.__raw = ''
          function()
            require("grug-far").open({
              prefills = {
                search = vim.fn.expand("<cword>"),
              }
            })
          end
        '';
        key = "<leader>rW";
        options.desc = "GrugFar rename word in project";
      }
      {
        mode = "v";
        action.__raw = ''
          function()
            require("grug-far").open({
              prefills = {
                search = require("grug-far").get_current_visual_selection(),
                paths = vim.fn.expand("%"),
              }
            })
          end
        '';
        key = "<leader>rw";
        options.desc = "GrugFar rename selection in buffer";
      }
      {
        mode = "v";
        action.__raw = ''
          function()
            require("grug-far").open({
              prefills = {
                search = require("grug-far").get_current_visual_selection(),
              }
            })
          end
        '';
        key = "<leader>rW";
        options.desc = "GrugFar rename selection in project";
      }
    ];
  in {
    keymaps = keymapUnlazy keymaps;
    plugins.grug-far = {
      enable = true;
      lazyLoad.settings = {
        cmd = "GrugFar";
        keymaps = keymap2Lazy keymaps;
      };
    };
    utils.wKeyList = wKeyObjMapIf cfg.enable [
      ["<leader>r" "󰛔" "GrugFar"]
    ];
  };
}
