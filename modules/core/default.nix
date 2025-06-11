{
  flake.modules.nixvim.core = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib.nixvim.utils) mkRaw;
    inherit (config.utils.mkKey) mkKeyMap keymap2Lazy keymapUnlazy;
    keymapsCom = builtins.map mkKeyMap (lib.optionals config.plugins.comment.enable [
      {
        action = "yy<Plug>(comment_toggle_linewise_current)p";
        key = "<localleader>cc";
        options.desc = "Duplicate and comment line";
      }
      {
        action = "ygv<Plug>(comment_toggle_linewise_visual)`>p";
        key = "<localleader>cc";
        mode = "x";
        options.desc = "Duplicate and comment visual block";
      }
    ]);
    keymapsFsh = builtins.map mkKeyMap (lib.optionals config.plugins.flash.enable [
        {
          action = mkRaw ''
            function()
              require("flash").jump()
            end
          '';
          key = "s";
          mode = [
            "n"
            "x"
            "o"
          ];
          options.desc = "Flash";
        }
        {
          action = mkRaw ''
            function()
              require("flash").remote()
            end
          '';
          key = "r";
          mode = "o";
          options.desc = "Remote Flash";
        }
        {
          action = mkRaw ''
            function()
              require("flash").toggle()
            end
          '';
          key = "<C-s>";
          mode = "c";
          options.desc = "Toggle Flash Search";
        }
        {
          action = mkRaw ''
            function()
              require("flash").jump({
                search = { mode = "search", max_length = 0 },
                label = { after = { 0, 0 } },
                pattern = "^"
              })
            end
          '';
          key = "<localleader>l";
          mode = "n";
          options.desc = "Hop to line";
        }
      ]
      ++ (lib.optionals config.plugins.treesitter.enable [
        {
          action = mkRaw ''
            function()
              require("flash").treesitter()
            end
          '';
          key = "S";
          mode = [
            "n"
            "x"
            "o"
          ];
          options.desc = "Flash Tressiter";
        }
        {
          action = mkRaw ''
            function()
              require("flash").treesitter_search()
            end
          '';
          key = "R";
          mode = [
            "x"
            "o"
          ];
          options.desc = "Flash Tressiter Search";
        }
      ]));
  in {
    colorschemes.kanagawa.enable = true;
    keymaps = keymapUnlazy (keymapsFsh ++ keymapsCom);
    extraPackages = with pkgs; [
      ripgrep
    ];
    extraPlugins = with pkgs; [
      local.age-nvim
      vimPlugins.unimpaired-nvim
    ];
    plugins = {
      lualine = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
      };
      lz-n = {
        enable = true;
        plugins = [
          {
            __unkeyed-1 = "unimpaired-nvim";
            after = ''
              function()
                require("unimpaired").setup()
              end
            '';
            event = "BufReadPre";
          }
          {
            __unkeyed-1 = "age-nvim";
            event = "DeferredUIEnter";
          }
        ];
      };
      comment = {
        enable = true;
        lazyLoad.settings.keys = keymap2Lazy keymapsCom;
        settings.pre_hook = lib.optionalString config.plugins.ts-context-commentstring.enable ''
          require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
        '';
      };
      flash = {
        enable = true;
        lazyLoad.settings.keys = keymap2Lazy keymapsFsh;
        settings = {
          jump.autojump = true;
          modes.char.multi_line = false;
        };
      };
      nvim-autopairs = {
        enable = true;
        # lazyLoad.settings.event = "BufReadPre";
        settings = {
          check_ts = true;
          disable_in_macro = true;
          disable_in_visualblock = true;
        };
      };
      nvim-surround = {
        enable = true;
        lazyLoad.settings.event = "BufReadPre";
      };
      rainbow-delimiters.enable = true;
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          nu
        ];
        settings = {
          highlight.enable = true;
        };
      };
      ts-context-commentstring = {
        enable = true;
        extraOptions = lib.mkIf config.plugins.comment.enable {
          enable_autocmd = false;
        };
      };
      which-key = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings.spec = config.utils.wKeyList;
      };
      vim-matchup = {
        enable = true;
        settings.matchparen_offscreen.method = "status";
      };
    };
    withPython3 = false;
    withRuby = false;
  };
}
