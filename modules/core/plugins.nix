{
  flake.modules.nixvim.core = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMapIf keymap2Lazy keymapUnlazy;
    keysComment = mkKeyMapIf config.plugins.comment.enable [
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
    ];
    keysFlash = mkKeyMapIf config.plugins.flash.enable ([
        {
          action.__raw = ''
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
          action.__raw = ''
            function()
              require("flash").jump()
            end
          '';
          key = "S";
          mode = [
            "n"
            "x"
            "o"
          ];
          options.desc = "Flash treesitter";
        }
        {
          action.__raw = ''
            function()
              require("flash").remote()
            end
          '';
          key = "r";
          mode = "o";
          options.desc = "Flash remote";
        }
        {
          action.__raw = ''
            function()
              require("flash").remote()
            end
          '';
          key = "R";
          mode = ["o" "x"];
          options.desc = "Flash remote treesitter";
        }
        {
          action.__raw = ''
            function()
              require("flash").toggle()
            end
          '';
          key = "<C-s>";
          mode = "c";
          options.desc = "Toggle Flash Search";
        }
        {
          action.__raw = ''
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
          action.__raw = ''
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
          action.__raw = ''
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
    # extraPlugins = with pkgs; [
    #   vimPlugins.unimpaired-nvim
    # ];
    keymaps = keysComment ++ (keymapUnlazy keysFlash);
    plugins = {
      lualine = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
      };
      lz-n = {
        enable = true;
        plugins = [
          # {
          #   __unkeyed-1 = "unimpaired-nvim";
          #   after = ''
          #     function()
          #       require("unimpaired").setup()
          #     end
          #   '';
          #   event = ["BufRead" "BufNewFile"];
          # }
        ];
      };
      comment = {
        enable = false;
        settings.pre_hook = lib.optionalString config.plugins.ts-context-commentstring.enable ''
          require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
        '';
      };
      flash = {
        enable = true;
        lazyLoad.settings.keys = keymap2Lazy keysFlash;
        settings = {
          jump.autojump = true;
          modes = {
            char = {
              enabled = false;
              multi_line = true;
              jump_labels = false;
            };
            search.enabled = true;
          };
        };
      };
      nvim-surround = {
        enable = true;
        lazyLoad.settings.event = ["BufRead" "BufNewFile"];
      };
      rainbow-delimiters = {
        enable = true;
        lazyLoad.settings.event = ["BufRead" "BufNewFile"];
      };
      snacks = {
        enable = true;
        settings = {
          bigfile.enable = true;
          quickfile.enable = true;
        };
      };
      which-key = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings.spec = config.utils.wKeyList;
      };
      vim-matchup = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings.matchparen_offscreen.method = "status";
      };
    };
  };
}
