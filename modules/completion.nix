{
  flake.modules.nixvim.completion = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.plugins.cmp;
  in {
    extraFiles = {
      "lua/snippets/utils.lua".source = ../lua/snippets_utils.lua;
    };
    extraPlugins = with pkgs.vimPlugins; [
      haskell-snippets-nvim
    ];
    plugins = {
      cmp = {
        enable = true;
        autoEnableSources = false;
        cmdline = let
          base_cfg = {
            completion.autocomplete = false;
            mapping = lib.nixvim.utils.mkRaw ''cmp.mapping.preset.cmdline()'';
          };
        in {
          ":" =
            base_cfg
            // {
              sources = [
                {
                  name = "path";
                  priority = 500;
                }
                {
                  name = "cmdline";
                  option.ignore_cmds = [
                    "Man"
                    "!"
                  ];
                  priority = 300;
                }
                {
                  name = "cmdline-history";
                  priority = 100;
                }
              ];
            };
          "/" =
            base_cfg
            // {
              sources = [
                {
                  name = "nvim_lsp_document_symbol";
                  priority = 500;
                }
                {
                  name = "cmdline-history";
                  priority = 300;
                }
                {
                  name = "buffer";
                  priority = 100;
                }
              ];
            };
          "?" =
            base_cfg
            // {
              sources = [
                {
                  name = "cmdline-history";
                }
              ];
            };
          "@" =
            base_cfg
            // {
              sources = [
                {
                  name = "cmdline-history";
                }
              ];
            };
        };
        luaConfig.pre = ''
          local ls = require("luasnip")
          local cmp = require("cmp")

          local function ctrl_l_func()
              if ls.expand_or_locally_jumpable() then
                  ls.expand_or_jump()
              elseif cmp.visible() then
                  cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                  cmp.complete()
              end
          end

          local function tab_func(dir)
              return function(fallback)
                  if ls.locally_jumpable(dir) then
                      ls.jump(dir)
                  else
                      fallback()
                  end
              end
          end

          local function next_prev_func(is_next, select_opts)
              local select_func
              local dir
              local key

              if is_next then
                  key = '<Down>'
                  dir = 1
                  select_func = cmp.select_next_item
              else
                  key = '<Up>'
                  dir = -1
                  select_func = cmp.select_prev_item
              end

              if select_func == nil then return end

              return {
                  c = function()
                      if cmp.visible() then
                          select_func(select_opts)
                      else
                          vim.api.nvim_feedkeys(
                              vim.api.nvim_replace_termcodes(key, true, true, true),
                              'n',
                              true
                          )
                      end
                  end,
                  i = function(fallback)
                      if cmp.visible()  then
                          select_func(select_opts)
                      else
                          fallback()
                      end
                  end,
                  s = function(fallback)
                      if ls.choice_active() then
                          ls.change_choice(dir)
                      else
                          fallback()
                      end
                  end,
              }
          end
        '';
        luaConfig.post = ''
          cmp.event:on(
              'confirm_done',
              require('nvim-autopairs.completion.cmp').on_confirm_done()
          )
        '';
        settings = {
          mapping = {
            "<C-y>" = ''
              cmp.mapping(function()
                if cmp.visible() then
                  cmp.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true
                  })
                elseif ls.choice_active() then
                  require('luasnip.extras.select_choice')()
                else
                  cmp.complete()
                end
              end, { 'i', 'c', 's' })'';
            "<CR>" = ''
              cmp.mapping({
                i = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                c = function(fallback)
                  if cmp.visible() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                  else
                    fallback()
                  end
                end,
              })
            '';
            "<C-e>" = "cmp.mapping(cmp.mapping.close(), { 'i', 'c' })";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-u>" = "cmp.mapping.scroll_docs(4)";
            "<C-n>" = "cmp.mapping(next_prev_func(true, { behavior = cmp.SelectBehavior.Select }))";
            "<C-p>" = "cmp.mapping(next_prev_func(false, { behavior = cmp.SelectBehavior.Select }))";
            "<C-l>" = ''
              cmp.mapping({
                          c = cmp.mapping.complete(),
                          s = ctrl_l_func,
                          i = ctrl_l_func,
                        })
            '';
            "<Tab>" = "cmp.mapping(tab_func(1), { 'i', 'c', 's' })";
            "<S-Tab>" = "cmp.mapping(tab_func(-1), { 'i', 'c', 's' })";
          };
          snippet.expand = ''
            function(args)
              ls.lsp_expand(args.body)
            end
          '';
          sources =
            [
              {
                name = "nvim_lsp";
                priority = 1000;
              }
              {
                name = "nvim_lsp_signature_help";
                priority = 1000;
              }
              {
                name = "nvim_lsp_document_symbol";
                priority = 1000;
              }
              {
                name = "treesitter";
                priority = 850;
              }
              {
                name = "luasnip";
                priority = 750;
              }
              {
                name = "buffer";
                priority = 500;
              }
              {
                name = "spell";
                priority = 400;
              }
              {
                name = "dictionary";
                priority = 400;
              }
              {
                name = "path";
                priority = 300;
              }
              {
                name = "nvim_lua";
                priority = 300;
              }
              {
                name = "neorg";
                priority = 300;
              }
            ]
            ++ (lib.optional config.plugins.render-markdown.enable {
              name = "render-markdown";
              priority = 300;
            })
            ++ (lib.optional config.plugins.minuet.enable {
              name = "minuet";
            });
          performance.fetching_timeout =
            if config.plugins.minuet.enable
            then 2000
            else 500;
        };
      };
      cmp-buffer.enable = cfg.enable;
      cmp-cmdline.enable = cfg.enable;
      cmp-cmdline-history.enable = cfg.enable;
      cmp-dictionary.enable = cfg.enable;
      cmp_luasnip.enable = cfg.enable && config.plugins.luasnip.enable;
      cmp-nvim-lsp.enable = cfg.enable && config.plugins.lsp.enable;
      cmp-nvim-lsp-document-symbol.enable = cfg.enable && config.plugins.lsp.enable;
      cmp-nvim-lsp-signature-help.enable = cfg.enable && config.plugins.lsp.enable;
      cmp-nvim-lua.enable = cfg.enable;
      cmp-spell.enable = cfg.enable;
      cmp-treesitter.enable = cfg.enable && config.plugins.treesitter.enable;
      cmp-path.enable = cfg.enable;
      friendly-snippets.enable = config.plugins.luasnip.enable;
      luasnip = {
        enable = true;
        filetypeExtend = {
          typescriptreact = ["typescript"];
        };
        fromLua = [{paths = ../lua/snippets;}];
        fromVscode = [{}];
        luaConfig.post = ''
          local ok, haskell_snippets = pcall(require, "haskell_snippets")
          if ok then
              ls.add_snippets('haskell', haskell_snippets.all, { key = 'haskell' })
          end
        '';
      };
      lspkind = {
        enable = cfg.enable && config.plugins.lsp.enable;
        cmp = {
          ellipsisChar = "...";
          maxWidth = 50;
        };
        mode = "symbol_text";
        extraOptions.show_labelDetails = true;
        # settings = {
        #   mode = "symbol_text";
        #   cmp = {
        #     max_width = 50;
        #     ellipsis_char = "...";
        #   };
        #   show_labelDetails = true;
        # };
      };
    };
  };
}
