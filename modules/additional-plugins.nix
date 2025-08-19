{
  flake.modules.nixvim.additional-plugins = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap keymap2Lazy;
    keymaps = builtins.map mkKeyMap [
      {
        action = "<cmd>UndotreeToggle<CR>";
        key = "<leader>U";
        options.desc = "Toggle Undotree";
      }
    ];
  in {
    inherit keymaps;
    extraPackages = with pkgs;
      lib.optionals pkgs.stdenv.isDarwin [
        pngpaste
      ];
    extraPlugins = with pkgs.vimPlugins;
      [
        mini-icons
        playground
        vim-gnupg
        vim-indent-object
        vim-table-mode
      ]
      ++ (with pkgs.local; [
        age-secret-nvim
      ]);
    extraConfigLua = ''
      require("age_secret").setup()
    '';
    globals = {
      GPGPreferArmor = 1;
      GPGPreferSign = 1;
    };
    plugins = {
      lz-n.plugins = [
        {
          __unkeyed-1 = "playground";
          cmd = "TSPlaygroundToggle";
        }
        {
          __unkeyed-1 = "vim-gnupg";
          ft = [
            "gpg"
            "asc"
            "pgp"
          ];
        }
      ];
      direnv.enable = true;
      helm.enable = true;
      indent-blankline = {
        enable = true;
        lazyLoad.settings.event = "BufReadPre";
        settings.indent = {
          char = [
            "|"
            "¦"
            "┆"
            "┊"
          ];
          priority = 50;
        };
      };
      nvim-bqf.enable = true;
      twilight = {
        enable = true;
        lazyLoad.settings.cmd = "Twilight";
      };
      undotree = {
        enable = true;
        settings.WindowLayout = 3;
      };
      vim-bbye = {
        enable = true;
        keymaps = {
          bdelete = "<localleader>q";
          bwipeout = "<localleader>Q";
        };
        keymapsSilent = true;
      };
      toggleterm = {
        enable = true;
        lazyLoad.settings = {
          keys = keymap2Lazy [
            (mkKeyMap {
              action = "<cmd>ToggleTerm<CR>";
              key = ''<C-\>'';
              options.desc = "ToggleTerm";
            })
          ];
        };
        settings = {
          open_mapping = "[[<C-\\>]]";
          hide_numbers = true;
        };
      };
    };
  };
}
