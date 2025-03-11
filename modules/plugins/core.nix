{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.my.mkKey) mkKeyMap keymapUnlazy keymap2Lazy;
  age-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "maximize-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "KingMichaelPark";
      repo = "/age.nvim";
      rev = "f1793e14123a7c5374a3744aacab9c283014fa1d";
      hash = "sha256-NcO7ebDJfjdh3jv+yzyxkOLmnV2mgzy++ltkDJ2NY7s=";
    };
  };
  keymapsFsh = builtins.map mkKeyMap (lib.optionals config.plugins.flash.enable [
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
            require("flash").remote()
          end
        '';
        key = "r";
        mode = "o";
        options.desc = "Remote Flash";
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
  extraPlugins = with pkgs.vimPlugins; [
    unimpaired-nvim
    age-nvim
  ];
  keymaps = keymapUnlazy keymapsFsh;
  plugins = {
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
      settings.spec = config.my.wKeyList;
    };
    vim-matchup = {
      enable = true;
      settings.matchparen_offscreen.method = "status";
    };
  };
}
