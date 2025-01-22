{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    haskell-snippets-nvim
  ];
  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = false;
      cmdline = {
        ":" = {
          completion.autocomplete = false;
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            {
              name = "path";
            }
            {
              name = "cmdline";
              option.ignore_cmds = [
                "Man"
                "!"
              ];
            }
            {
              name = "cmdline-history";
            }
          ];
        };
        "/" = {
          completion.autocomplete = false;
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources.__raw = ''
            cmp.config.sources({
                        {
                          name = "nvim_lsp_document_symbol";
                        },
                        {
                          name = "cmdline-history";
                        },
                      }, {
                        {
                          name = "buffer";
                        },
                      })'';
        };
        "?" = {
          completion.autocomplete = false;
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            {
              name = "cmdline-history";
            }
          ];
        };
        "@" = {
          completion.autocomplete = false;
          mapping.__raw = "cmp.mapping.preset.cmdline()";
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
          "<Tab>" = "cmp.mapping(tab_func(1), { 'i', 'c' })";
          "<S-Tab>" = "cmp.mapping(tab_func(-1), { 'i', 'c' })";
        };
        snippet.expand = ''
          function(args)
            ls.lsp_expand(args.body)
          end
        '';
        sources.__raw = ''
          cmp.config.sources({
            { name = 'nvim_lsp_signature_help' },
            { name = 'nvim_lua' },
            { name = 'luasnip' },
            { name = 'nvim_lsp' },
            { name = 'neorg' },
          }, {
            { name = 'buffer' },
            { name = 'path' },
          })'';
      };
    };
    cmp-buffer.enable = true;
    cmp-cmdline.enable = true;
    cmp-cmdline-history.enable = true;
    cmp_luasnip.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-document-symbol.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;
    cmp-nvim-lua.enable = true;
    cmp-path.enable = true;
    friendly-snippets.enable = true;
    luasnip = {
      enable = true;
      filetypeExtend = {
        typescriptreact = [ "typescript" ];
      };
      fromLua = [ { paths = ../../lua/snippets; } ];
      fromVscode = [ { } ];
      luaConfig.post = ''
        local ok, haskell_snippets = pcall(require, "haskell_snippets")
        if ok then
            ls.add_snippets('haskell', haskell_snippets.all, { key = 'haskell' })
        end
      '';
    };
    lspkind = {
      enable = true;
      mode = "symbol_text";
      extraOptions = {
        show_labelDetails = true;
      };
      cmp = {
        maxWidth = 50;
        ellipsisChar = "...";
      };
    };
  };
}
