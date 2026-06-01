{
  nixpkgs.allowedUnfreePackages = [
    "vim-table-mode"
  ];
  flake.modules.nixvim.additional-plugins = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap mkKeyMapIf;
    keymapsTerm = let
      cfg = config.plugins.snacks;
    in
      mkKeyMapIf (cfg.enable && cfg.settings.terminal.enabled) [
        {
          action.__raw = ''
            function()
              require("snacks").terminal.toggle()
            end
          '';
          key = "<leader>'";
          options.desc = "Toggle Terminal";
        }
      ];
    keymaps =
      mkKeyMap [
        {
          action = "<cmd>UndotreeToggle<CR>";
          key = "<leader>U";
          options.desc = "Toggle Undotree";
        }
      ]
      ++ (lib.optional config.plugins.blink-indent.enable {
        action.__raw = ''
          function()
            local indent = require("blink.indent")
            indent.enable(not indent.is_enabled())
            vim.notify(string.format("Indent lines is %s", bool2str(indent.is_enabled())), "info")
          end
        '';
        key = "<leader>ui";
        options.desc = "Toggle indent lines";
      })
      ++ (lib.optionals config.plugins.blink-pairs.enable [
        {
          action.__raw = ''
            function()
              vim.b.blink_pairs = vim.b[0].blink_pairs == false
              vim.notify(string.format("Buffer pairs is %s", bool2str(vim.b[0].blink_pairs ~= false)), "info")
            end
          '';
          key = "<leader>up";
          options.desc = "Toggle buffer pairs";
        }
        {
          action.__raw = ''
            function()
              vim.g.blink_pairs = vim.g.blink_pairs == false
              vim.notify(string.format("Global pairs is %s", bool2str(vim.g.blink_pairs ~= false)), "info")
            end
          '';
          key = "<leader>uP";
          options.desc = "Toggle global pairs";
        }
      ])
      ++ keymapsTerm;
  in {
    inherit keymaps;
    extraPackages = with pkgs;
      (lib.optionals pkgs.stdenv.isDarwin [
        pngpaste
      ])
      ++ [age];
    extraPlugins = with pkgs.vimPlugins;
      [
        kmonad-vim
        mini-icons
        term-edit-nvim
        vim-gnupg
        vim-table-mode
      ]
      ++ (with pkgs.local; [
        age-secret-nvim
        age-nvim
      ]);
    extraConfigLua = ''
      require("age_secret").setup()
      require("term-edit").setup({
        prompt_end = {"❯%s%s", "❯%s%s"}
      })
    '';
    globals = {
      GPGPreferArmor = 1;
      GPGPreferSign = 1;
    };
    plugins = {
      blink-indent = {
        enable = true;
        lazyLoad.settings.events = ["BufReadPost" "BufNewFile"];
        settings = {
          static.char = "¦";
          scope.char = "¦";
        };
      };
      blink-pairs = {
        enable = true;
        lazyLoad.settings.events = ["BufReadPost" "BufNewFile"];
      };
      lz-n.plugins = [
        {
          __unkeyed-1 = "age-nvim";
          enabled = true;
          event = "DeferredUIEnter";
        }
        {
          __unkeyed-1 = "vim-gnupg";
          enabled = true;
          ft = [
            "gpg"
            "asc"
            "pgp"
          ];
        }
      ];
      direnv = {
        enable = true;
        settings = {
          edit_mode = "split";
          silent_load = 1;
        };
      };
      helm.enable = true;
      nvim-bqf.enable = true;
      twilight = {
        enable = true;
        lazyLoad.settings.cmd = "Twilight";
      };
      undotree = {
        enable = true;
        settings.WindowLayout = 3;
      };
    };
  };
}
