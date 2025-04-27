{
  lib,
  config,
  ...
}: let
  inherit (config.my.mkKey) mkKeyMap wKeyObj;
  cfg = config.plugins.harpoon;
in {
  keymaps = builtins.map mkKeyMap (lib.optionals cfg.enable [
      {
        action.__raw = ''
          function()
            if vim.v.count > 0 then
                return require("harpoon.ui").nav_file(vim.v.count)
            end

            require("harpoon.ui").nav_next()
          end
        '';
        key = "<leader>hg";
        mode = "n";
        options.desc = "Harpoon goto next file";
      }
      {
        action.__raw = ''
          function()
            if vim.v.count > 0 then
                return require("harpoon.ui").nav_file(vim.v.count)
            end

            require("harpoon.ui").nav_prev()
          end
        '';
        key = "<leader>hG";
        mode = "n";
        options.desc = "Harpoon goto prev file";
      }
      {
        action.__raw = ''
          function()
            require("harpoon.term").gotoTerminal(vim.v.count1)
          end
        '';
        key = "<leader>ht";
        mode = "n";
        options.desc = "Harpoon goto terminal";
      }
      {
        action.__raw = ''
          function()
            local harpoon = require("harpoon")
            hapoon.ui:toggle_quick_menu(harpoon:list())
          end
        '';
        key = "<leader>hu";
        mode = "n";
        options.desc = "Harpoon quick menu";
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():add()
          end
        '';
        key = "<leader>hm";
        mode = "n";
        options.desc = "Harpoon add file";
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(1)
          end
        '';
        key = "<leader>hh";
        mode = "n";
        options.desc = "Harpoon select 1";
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(2)
          end
        '';
        key = "<leader>ht";
        mode = "n";
        options.desc = "Harpoon select 2";
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(3)
          end
        '';
        key = "<leader>hn";
        mode = "n";
        options.desc = "Harpoon select 3";
      }
      {
        action.__raw = ''
          function()
            require("harpoon"):list():select(4)
          end
        '';
        key = "<leader>hs";
        mode = "n";
        options.desc = "Harpoon select 4";
      }
    ]
    ++ (lib.optionals config.plugins.telescope.enable [
      {
        action.__raw = ''
          function()
            require("telescope").extensions.harpoon.marks()
          end
        '';
        key = "<leader>hU";
        mode = "n";
        options.desc = "Harpoon telescope menu";
      }
    ]));
  plugins = {
    harpoon = {
      enable = true;
      enableTelescope = config.plugins.telescope.enable;
    };
  };
  my.wKeyList = lib.optionals cfg.enable [
    (wKeyObj ["<leader>h" "󱡀" "Harpoon"])
  ];
}
