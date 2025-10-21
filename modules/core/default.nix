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
    keymaps = (keymapUnlazy keymapsFsh) ++ keymapsCom;
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
        # lazyLoad.settings.keys = keymap2Lazy keymapsCom;
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
        luaConfig.post = ''
          local autopairs = require("nvim-autopairs")
          local rule = require("nvim-autopairs.rule")
          local conds = require("nvim-autopairs.conds")
          local utils = require("nvim-autopairs.utils")
          local ts_conds = require("nvim-autopairs.ts-conds")

          local is_not_ts_node_comment_one_back = function()
            return function(info)
              local p = vim.api.nvim_win_get_cursor(0)
              local pos_adjusted = {p[1] - 1, p[2] - 1}
              vim.treesitter.get_parser():parse()
              local target = vim.treesitter.get_node({pos = pos_adjusted, ignore_injections = false})
              if target ~= nil and utils.is_in_table({"comment"}, target:type()) then
                return false
              end

              local rest_of_line = info.line:sub(info.col)
              return rest_of_line:match('^%s*$') ~= nil
            end
          end
          local brackets = {{ '(', ')' }, { '[', ']' }, { '{', '}' }}

          autopairs.add_rules({
            rule("<", ">"):with_pair(conds.before_regex('%a+:?:?$', 3)):with_move(function(opts)
              return opts.char == '>'
            end),
            rule("= ", ";", "nix"):with_pair(is_not_ts_node_comment_one_back()):set_end_pair_length(1),
            rule("{", "},", "lua"):with_pair(ts_conds.is_ts_node({"table_constructor"})),
            rule("'", "',", "lua"):with_pair(ts_conds.is_ts_node({"table_constructor"})),
            rule('"', '",', "lua"):with_pair(ts_conds.is_ts_node({"table_constructor"})),
            rule(' ', ' '):with_pair(function(opts)
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
              }, pair)
            end):with_move(conds.none()):with_cr(conds.none()):with_del(function(opts)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local context = opts.line:sub(col - 1, col + 2)
              return vim.tbl_contains({
                brackets[1][1] .. ' ' .. brackets[1][2],
                brackets[2][1] .. ' ' .. brackets[2][2],
                brackets[3][1] .. ' ' .. brackets[3][2],
              }, context)
            end),
          })

          for _, bracket in pairs(brackets) do
            autopairs.add_rules({
              rule(bracket[1] .. ' ', ' ' .. bracket[2]):with_pair(conds.none()):with_move(function(opts)
                return opts.char == bracket[2]
              end):with_del(conds.none()):use_key(bracket[2]):replace_map_cr(function(_)
                return '<C-c>2xi<CR><C-c>O'
              end),
            })
          end
        '';
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
      snacks = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings = {
          bigfile.enable = true;
          quickfile.enable = true;
        };
      };
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
        settings = lib.mkIf config.plugins.comment.enable {
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
