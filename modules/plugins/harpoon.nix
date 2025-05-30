{
  lib,
  config,
  ...
}: let
  inherit (config.my.mkKey) mkKeyMap wKeyObj;
  inherit (lib.nixvim.utils) mkRaw;
  cfg = config.plugins.harpoon;
in {
  keymaps = builtins.map mkKeyMap (lib.optionals cfg.enable [
      {
        action = mkRaw ''
          function()
            if vim.v.count > 0 then
                return require("harpoon.ui").nav_file(vim.v.count)
            end

            require("harpoon.ui").nav_next()
          end
        '';
        key = "<leader>hg";
        options.desc = "Harpoon goto next file";
      }
      {
        action = mkRaw ''
          function()
            if vim.v.count > 0 then
                return require("harpoon.ui").nav_file(vim.v.count)
            end

            require("harpoon.ui").nav_prev()
          end
        '';
        key = "<leader>hG";
        options.desc = "Harpoon goto prev file";
      }
      {
        action = mkRaw ''
          function()
            require("harpoon.term").gotoTerminal(vim.v.count1)
          end
        '';
        key = "<leader>ht";
        options.desc = "Harpoon goto terminal";
      }
      {
        action = mkRaw ''
          function()
            local harpoon = require("harpoon")
            hapoon.ui:toggle_quick_menu(harpoon:list())
          end
        '';
        key = "<leader>hu";
        options.desc = "Harpoon quick menu";
      }
      {
        action = mkRaw ''
          function()
            require("harpoon"):list():add()
          end
        '';
        key = "<leader>hm";
        options.desc = "Harpoon add file";
      }
      {
        action = mkRaw ''
          function()
            require("harpoon"):list():select(1)
          end
        '';
        key = "<leader>hh";
        options.desc = "Harpoon select 1";
      }
      {
        action = mkRaw ''
          function()
            require("harpoon"):list():select(2)
          end
        '';
        key = "<leader>ht";
        options.desc = "Harpoon select 2";
      }
      {
        action = mkRaw ''
          function()
            require("harpoon"):list():select(3)
          end
        '';
        key = "<leader>hn";
        options.desc = "Harpoon select 3";
      }
      {
        action = mkRaw ''
          function()
            require("harpoon"):list():select(4)
          end
        '';
        key = "<leader>hs";
        options.desc = "Harpoon select 4";
      }
    ]
    ++ (lib.optionals config.plugins.telescope.enable [
      {
        action = mkRaw ''
          function()
            require("telescope").extensions.harpoon.marks()
          end
        '';
        key = "<leader>hU";
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
