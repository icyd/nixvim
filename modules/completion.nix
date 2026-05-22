_topLevel: let
  lazyPlugin = {enable ? true, ...} @ args:
    {
      inherit enable;
      lazyLoad.settings.event = [
        "InsertEnter"
        "CmdlineEnter"
      ];
    }
    // (removeAttrs args ["enable"]);
in {
  nixpkgs.allowedUnfreePackages = [
    "blink-cmp-spell"
  ];
  flake.modules.nixvim.core = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMapIf;
    inherit (lib.nixvim.utils) mkRaw;
    keymaps = mkKeyMapIf config.plugins.luasnip.enable [
      {
        action.__raw = ''
          function()
            local luasnip = require("luasnip")
            if luasnip.choice_active() then
              luasnip.change_choice(1)
            end
          end
        '';
        key = "<C-n>";
        mode = ["i" "s"];
        options.desc = "Luasnip next choice";
      }
      {
        action.__raw = ''
          function()
            local luasnip = require("luasnip")
            if luasnip.choice_active() then
              luasnip.change_choice(-1)
            end
          end
        '';
        key = "<C-p>";
        mode = ["i" "s"];
        options.desc = "Luasnip prev choice";
      }
    ];
  in {
    inherit keymaps;
    extraPlugins = lib.optionals config.plugins.blink-cmp.enable (with pkgs.vimPlugins; [
      blink-cmp-conventional-commits
    ]);
    plugins = {
      blink-cmp = lazyPlugin {
        enable = true;
        lazyLoad.settings = {
          event = [
            "InsertEnter"
            "CmdlineEnter"
          ];
          before.__raw = ''
            function()
              require("lz.n").trigger_load("luasnip")
            end
          '';
        };
        settings = {
          cmdline.completion = {
            list.selection = {
              auto_insert = false;
              preselect = false;
            };
            menu.auto_show = true;
          };
          fuzzy = {
            implementation = "prefer_rust_with_warning";
            sorts = ["exact" "score" "sort_text"];
          };
          completion = {
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
            list.selection = {
              auto_insert = false;
              preselect = false;
            };
            menu = {
              auto_show = true;
              auto_show_delay_ms = 0;
              # draw.columns.__raw = ''
              #   {
              #     { "label", "label_description", gap = 1 },
              #     { "kind_icon", "kind", gap = 1 },
              #     { "source_name", gap = 1 },
              #   }
              # '';
            };
          };
          keymap = {
            preset = "default";
            "<CR>" = [
              "accept"
              "fallback"
            ];
          };
          signature = {
            enabled = true;
          };
          snippets.preset =
            if config.plugins.luasnip.enable
            then "luasnip"
            else "default";
          sources = let
            common_sources = [
              "lsp"
              "snippets"
              "path"
              "buffer"
            ];
          in {
            default =
              common_sources;
            per_filetype = {
              lua = lib.mkIf config.plugins.lazydev.enable (mkRaw ''
                {
                  inherit_defaults = true;
                  "lazydev";
                }'');
              gitcommit =
                (lib.remove "lsp" common_sources)
                ++ (lib.optional (lib.elem pkgs.vimPlugins.blink-cmp-conventional-commits config.extraPlugins) "conventional_commits")
                ++ (lib.optional config.plugins.blink-cmp-git.enable "git");
            };
            providers = {
              buffer = {
                score_offset = 40;
                min_keyword_length = 3;
                max_items = 10;
              };
              conventional_commits = {
                name = "Conventional Commits";
                module = "blink-cmp-conventional-commits";
                enabled.__raw = ''function() return vim.bo.filetype == "gitcommit" end'';
                score_offset = 70;
              };
              git = lib.mkIf config.plugins.blink-cmp-git.enable {
                name = "Git";
                module = "blink-cmp-git";
                enabled.__raw = ''function() return vim.bo.filetype == "gitcommit" end'';
                score_offset = 70;
              };
              path = {
                score_offset = 55;
              };
              snippets = {
                should_show_items.__raw = ''
                  function()
                    return not require("luasnip").choice_active()
                  end
                '';
                score_offset = 60;
              };
            };
          };
        };
      };
      blink-cmp-git = lazyPlugin {inherit (config.plugins.blink-cmp) enable;};
      luasnip = {
        enable = true;
        lazyLoad.settings = {
          event = "InsertEnter";
        };
        fromLua = [
          {paths = ../lua/snippets;}
        ];
        settings =
          {
            enable_autosnippets = true;
          }
          // (lib.mkIf config.plugins.luasnip-snippets.enable {
            ft_func.__raw = ''require("luasnip_snippets.common.snip_utils").ft_func'';
            load_ft_func.__raw = ''require("luasnip_snippets.common.snip_utils").load_ft_func'';
          });
      };
      luasnip-snippets.enable = true;
    };
  };
  flake.modules.nixvim.completion = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib.nixvim.utils) mkRaw;
  in {
    extraPackages = with pkgs; [wordnet];
    extraPlugins = lib.optionals config.plugins.blink-cmp.enable (with pkgs.vimPlugins;
      [
        blink-cmp-env
        blink-cmp-yanky
      ]
      ++ (with pkgs.local; [
        blink-cmp-luasnip-choice
        blink-cmp-wezterm
      ]));
    plugins = {
      blink-cmp = lazyPlugin {
        settings = {
          completion.menu.draw.components.kind_icon.text.__raw = lib.mkIf config.plugins.lspkind.enable ''
            function(ctx)
              return require("lspkind").symbol_map[ctx.kind] or ""
            end
          '';
          sources = let
            common_sources = [
              "lsp"
              "snippets"
              "path"
              "buffer"
            ];
          in {
            default =
              common_sources
              ++ lib.optional (lib.elem pkgs.local.blink-cmp-luasnip-choice config.extraPlugins) "choice"
              ++ lib.optional config.plugins.blink-emoji.enable "emoji"
              ++ lib.optional (lib.elem pkgs.vimPlugins.blink-cmp-env config.extraPlugins) "env"
              ++ lib.optional config.plugins.blink-cmp-dictionary.enable "dictionary"
              ++ lib.optional config.plugins.blink-ripgrep.enable "ripgrep"
              ++ lib.optional config.plugins.blink-cmp-spell.enable "spell"
              ++ lib.optional (lib.elem pkgs.vimPlugins.blink-cmp-yanky config.extraPlugins) "yank"
              ++ lib.optional (lib.elem pkgs.local.blink-cmp-wezterm config.extraPlugins) "wezterm";
            per_filetype = {
              lua = lib.mkIf config.plugins.lazydev.enable (mkRaw ''
                {
                  inherit_defaults = true;
                  "lazydev";
                }'');
              gitcommit =
                (lib.remove "lsp" common_sources)
                ++ (lib.optional (lib.elem pkgs.vimPlugins.blink-cmp-conventional-commits config.extraPlugins) "conventional_commits")
                ++ (lib.optional config.plugins.blink-cmp-git.enable "git");
            };
            providers = {
              choice = {
                name = "LuaSnip Choice Nodes";
                module = "blink-cmp-luasnip-choice";
                score_offset = 65;
              };
              dictionary = lib.mkIf config.plugins.blink-cmp-dictionary.enable {
                name = "Dict";
                module = "blink-cmp-dictionary";
                max_items = 8;
                min_keyword_length = 3;
                score_offset = 10;
              };
              emoji = lib.mkIf config.plugins.blink-emoji.enable {
                name = "Emoji";
                module = "blink-emoji";
                score_offset = 3;
              };
              env = {
                name = "Env";
                module = "blink-cmp-env";
                score_offset = 50;
              };
              lsp = {
                score_offset = 80;
              };
              path = {
                score_offset = 55;
              };
              ripgrep = lib.mkIf config.plugins.blink-ripgrep.enable {
                name = "Ripgrep";
                module = "blink-ripgrep";
                async = true;
                timeout_ms = 500;
                max_items = 10;
                min_keyword_length = 3;
                score_offset = 5;
                opts = {
                  prefix_min_len = 5;
                  backend.use = "gitgrep-or-ripgrep";
                  ripgrep.search_casing = "--smart-case";
                };
              };
              spell = lib.mkIf config.plugins.blink-cmp-spell.enable {
                name = "Spell";
                module = "blink-cmp-spell";
                max_items = 5;
                min_keyword_length = 3;
                score_offset = 15;
              };
              yank = lib.mkIf (lib.elem pkgs.vimPlugins.blink-cmp-yanky config.extraPlugins) {
                name = "yank";
                module = "blink-yanky";
                max_items = 5;
                score_offset = 70;
                opts = {
                  minLength = 5;
                  onlyCurrentFiletype = true;
                };
              };
              wezterm = lib.mkIf (lib.elem pkgs.local.blink-cmp-wezterm config.extraPlugins) {
                name = "wezterm";
                module = "blink-cmp-wezterm";
                max_items = 5;
                score_offset = 50;
                opts = {
                  all_panes = true;
                  triggered_only = true;
                  trigger_chars = ["."];
                };
              };
            };
          };
        };
      };
      blink-cmp-dictionary = lazyPlugin {inherit (config.plugins.blink-cmp) enable;};
      blink-emoji = lazyPlugin {inherit (config.plugins.blink-cmp) enable;};
      blink-cmp-git = lazyPlugin {inherit (config.plugins.blink-cmp) enable;};
      blink-cmp-spell = lazyPlugin {inherit (config.plugins.blink-cmp) enable;};
      blink-ripgrep = lazyPlugin {inherit (config.plugins.blink-cmp) enable;};
      luasnip = {
        filetypeExtend.typescriptreact = ["typescript"];
      };
      copilot-cmp = {
        inherit (config.plugins.cmp) enable;
        settings.fix_pairs = false;
      };
    };
  };
}
