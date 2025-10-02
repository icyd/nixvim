{
  flake.modules.nixvim.additional-plugins = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib.nixvim.utils) mkRaw;
    inherit (config.utils.mkKey) mkKeyMap keymap2Lazy;
    keymapsTerm = let
      cfg = config.plugins.snacks;
    in
      builtins.map mkKeyMap (lib.optionals (cfg.enable && cfg.settings.terminal.enable) [
        {
          action = mkRaw ''
            function()
              require("snacks").terminal.toggle()
            end
          '';
          key = "<leader>'";
          options.desc = "Toggle Terminal";
        }
      ]);
    keymapsSnk = let
      cfg = config.plugins.snacks;
    in
      builtins.map mkKeyMap (lib.optionals (cfg.enable && cfg.settings.bufdelete.enable) [
        {
          action = mkRaw ''
            function()
              require("snacks").bufdelete.delete()
            end
          '';
          key = "<localleader>bq";
          options.desc = "BufDelete";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").bufdelete.delete({force=true})
            end
          '';
          key = "<localleader>bQ";
          options.desc = "BufDelete force";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").bufdelete.all()
            end
          '';
          key = "<localleader>bA";
          options.desc = "BufDelete all";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").bufdelete.other()
            end
          '';
          key = "<localleader>bO";
          options.desc = "BufDelete other";
        }
      ]);
    keymaps =
      builtins.map mkKeyMap [
        {
          action = "<cmd>UndotreeToggle<CR>";
          key = "<leader>U";
          options.desc = "Toggle Undotree";
        }
      ]
      ++ keymapsSnk ++ keymapsTerm;
  in {
    inherit keymaps;
    extraPackages = with pkgs;
      lib.optionals pkgs.stdenv.isDarwin [
        pngpaste
      ];
    extraPlugins = with pkgs.vimPlugins;
      [
        kmonad-vim
        mini-icons
        playground
        vim-gnupg
        # vim-indent-object
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
        enable = false;
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
      snacks = let
        cfg = config.plugins.snacks;
      in {
        luaConfig.post = lib.mkIf (cfg.enable
          && cfg.settings.debug.enable) ''
          _G.dd = function(...)
            require("snacks").debug.inspect(...)
          end
          _G.bt = function(...)
            require("snacks").debug.backtrace(...)
          end
        '';
        settings = {
          bufdelete.enable = cfg.enable;
          debug.enable = cfg.enable;
          indent.enable = cfg.enable;
          scope.enable = cfg.enable;
          scroll.enable = cfg.enable;
          statuscolumn.enable = cfg.enable;
          terminal.enable = true;
        };
      };
      twilight = {
        enable = true;
        lazyLoad.settings.cmd = "Twilight";
      };
      undotree = {
        enable = true;
        settings.WindowLayout = 3;
      };
      vim-bbye = let
        cfg = config.plugins.snacks;
      in {
        enable = !(cfg.enable && cfg.settings.bufdelete.enable);
        keymaps = {
          bdelete = "<localleader>q";
          bwipeout = "<localleader>Q";
        };
        keymapsSilent = true;
      };
      toggleterm = {
        enable = !(config.plugins.snacks.enable && config.plugins.snacks.settings.terminal.enable);
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
