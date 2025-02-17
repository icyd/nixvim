{
  lib,
  config,
  ...
}: let
  inherit (config.my.mkKey) keymap2mkKeyMap wKeyObj;
  cfg = config.plugins.harpoon;
in {
  keymaps = keymap2mkKeyMap (lib.optionals cfg.enable [
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
      keymaps = {
        addFile = "<leader>hm";
        toggleQuickMenu = "<leader>hu";
      };
    };
  };
  my.wKeyList = lib.optionals cfg.enable [
    (wKeyObj ["<leader>h" "󱡀" "Harpoon"])
  ];
}
