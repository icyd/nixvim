{
  flake.modules.nixvim.core = {
    lib,
    config,
    ...
  }: {
    plugins = {
      treesitter = {
        enable = true;
        nixGrammars = true;
        highlight.enable = true;
        indent.enable = true;
        grammarPackages = lib.filter (i:
          lib.elem i.pname (map (p: "tree-sitter-${p}") [
            "bash"
            "gitcommit"
            "gitignore"
            "json"
            "lua"
            "markdown"
            "markdown_inline"
            "nix"
            "nu"
            "query"
            "regex"
            "toml"
            "yaml"
          ]))
        config.plugins.treesitter.package.allGrammars;
      };
      ts-comments = {
        enable = true;
        lazyLoad.settings.event = "BufReadPre";
      };
      ts-context-commentstring = {
        enable = true;
        settings.enable_autocmd = false;
        luaConfig.post = ''
          local get_option = vim.filetype.get_option
          vim.filetype.get_option = function(filetype, option)
            return option == "commentstring"
            and require("ts_context_commentstring.internal").calculate_commentstring()
            or get_option(filetype, option)
          end
        '';
      };
    };
  };
  flake.modules.nixvim.treesitter = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap mkKeyMapIf keymap2Lazy keymapUnlazy;
    keysTSContext = mkKeyMapIf config.plugins.treesitter-context.enable [
      {
        action = "<cmd>TSContext toggle<CR>";
        key = "<leader>ut";
        options.desc = "Treesitter context toggle";
      }
    ];
    keysTSTextObjs = mkKeyMapIf config.plugins.treesitter-textobjects.enable [
      {
        mode = ["n" "x" "o"];
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move()
          end
        '';
        key = ";";
        options.desc = "Repeat last move";
      }
      {
        mode = ["n" "x" "o"];
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.repeatable_move").repeat_last_move_opposite()
          end
        '';
        key = ",";
        options.desc = "Repeat last move opposite direction";
      }
      {
        mode = ["n" "x" "o"];
        action.__raw = ''
          require("nvim-treesitter-textobjects.repeatable_move").builtin_f_expr
        '';
        key = "f";
        options.desc = "Go to char";
        options.expr = true;
      }
      {
        mode = ["n" "x" "o"];
        action.__raw = ''
          require("nvim-treesitter-textobjects.repeatable_move").builtin_F_expr
        '';
        key = "F";
        options.desc = "Go to char opposite direction";
        options.expr = true;
      }
      {
        mode = ["n" "x" "o"];
        action.__raw = ''
          require("nvim-treesitter-textobjects.repeatable_move").builtin_t_expr
        '';
        key = "t";
        options.desc = "Go until char";
        options.expr = true;
      }
      {
        mode = ["n" "x" "o"];
        action.__raw = ''
          require("nvim-treesitter-textobjects.repeatable_move").builtin_T_expr
        '';
        key = "T";
        options.desc = "Go until char opposite direction";
        options.expr = true;
      }
      {
        mode = ["n" "x" "o"];
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
          end
        '';
        key = "]s";
        options.desc = "Treesitter: Go to next start of scope";
      }
      # move keymaps
      {
        mode = ["n" "x" "o"];
        key = "]m";
        options.desc = "Treesitter: Go to next start of function/method";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "]f";
        options.desc = "Treesitter: Go to next start of function call";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_next_start("@call.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "]c";
        options.desc = "Treesitter: Go to next start of class";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "]i";
        options.desc = "Treesitter: Go to next start of conditional";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "]l";
        options.desc = "Treesitter: Go to next start of loop";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_next_start("@loop.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "]s";
        options.desc = "Treesitter: Go to next start of scope";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "]M";
        options.desc = "Treesitter: Go to next end of function/method";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "]F";
        options.desc = "Treesitter: Go to next end of function caol";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_next_end("@call.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "]C";
        options.desc = "Treesitter: Go to next end of class";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "]I";
        options.desc = "Treesitter: Go to next end of conditional";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_next_end("@conditional.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "]L";
        options.desc = "Treesitter: Go to next end of loop";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_next_end("@loop.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "[m";
        options.desc = "Treesitter: Go to prev start of function/method";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "[f";
        options.desc = "Treesitter: Go to prev start of function call";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_previous_start("@call.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "[c";
        options.desc = "Treesitter: Go to prev start of class";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "[i";
        options.desc = "Treesitter: Go to prev start of conditional";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "[l";
        options.desc = "Treesitter: Go to prev start of loop";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_previous_start("@loop.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "[M";
        options.desc = "Treesitter: Go to prev end of function/method";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "[F";
        options.desc = "Treesitter: Go to prev end of function call";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_previous_end("@call.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "[C";
        options.desc = "Treesitter: Go to prev end of class";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "[I";
        options.desc = "Treesitter: Go to prev end of conditional";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_previous_end("@conditional.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["n" "x" "o"];
        key = "[L";
        options.desc = "Treesitter: Go to prev end of loop";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.move").goto_previous_end("@loop.outer", "textobjects")
          end
        '';
      }
      # select keymaps
      {
        mode = ["x" "o"];
        key = "a=";
        options.desc = "Treesitter: Select outer part of assignment";
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.select").select_textobject("@assignment.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "i=";
        options.desc = "Treesitter: Select inner part of assignment";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@assignment.inner", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "l=";
        options.desc = "Treesitter: Select left side of assignment";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@assignment.lhs", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "r=";
        options.desc = "Treesitter: Select right side of assignment";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@assignment.rhs", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "aa";
        options.desc = "Treesitter: Select outer part of parameter/argument";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "ia";
        options.desc = "Treesitter: Select inner part of parameter/argument";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "ai";
        options.desc = "Treesitter: Select outer part of conditional";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@conditional.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "ii";
        options.desc = "Treesitter: Select inner part of conditional";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@conditional.inner", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "al";
        options.desc = "Treesitter: Select outer part of loop";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@loop.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "il";
        options.desc = "Treesitter: Select inner part of loop";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@loop.inner", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "af";
        options.desc = "Treesitter: Select outer part of function call";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@call.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "if";
        options.desc = "Treesitter: Select inner part of function call";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@call.inner", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "am";
        options.desc = "Treesitter: Select outer method/function";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "im";
        options.desc = "Treesitter: Select inner method/function";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "ac";
        options.desc = "Treesitter: Select outer class";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
          end
        '';
      }
      {
        mode = ["x" "o"];
        key = "ic";
        options.desc = "Treesitter: Select inner class";
        action.__raw = ''
          function()
          require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
          end
        '';
      }
      # swap keymaps
      {
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
          end
        '';
        key = "<leader>na";
        options.desc = "Treesitter: Swap next parameter";
      }
      {
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.swap").swap_next("@function.outer")
          end
        '';
        key = "<leader>nm";
        options.desc = "Treesitter: Swap next function/method";
      }
      {
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.swap").swap_next("@class.outer")
          end
        '';
        key = "<leader>nc";
        options.desc = "Treesitter: Swap next class";
      }
      {
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
          end
        '';
        key = "<leader>pa";
        options.desc = "Treesitter: Swap previous parameter";
      }
      {
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.swap").swap_previous("@function.outer")
          end
        '';
        key = "<leader>pm";
        options.desc = "Treesitter: Swap previous function/method";
      }
      {
        action.__raw = ''
          function()
            require("nvim-treesitter-textobjects.swap").swap_previous("@class.outer")
          end
        '';
        key = "<leader>pc";
        options.desc = "Treesitter: Swap previous class";
      }
    ];
    keysTS =
      (mkKeyMap [
        {
          mode = "x";
          action.__raw = ''
            function()
              require("vim.treesitter._select").select_prev(vim.v.count1)
            end
          '';
          key = "[n";
          options.desc = "Select previous treesitter node";
        }
        {
          mode = "x";
          action.__raw = ''
            function()
              require("vim.treesitter._select").select_next(vim.v.count1)
            end
          '';
          key = "]n";
          options.desc = "Select next treesitter node";
        }
        {
          mode = ["x" "o"];
          action.__raw = ''
            function()
              if vim.treesitter.get_parser(nil, nil, {error=false}) then
                require("vim.treesitter._select").select_child(vim.v.count1)
              else
                vim.lsp.buf.selection_range(-vim.v.count1)
              end
            end
          '';
          key = "in";
          options.desc = "Select child treesitter node or inner lsp selection";
        }
      ])
      ++ keysTSContext ++ keysTSTextObjs;
  in {
    keymaps = keysTS ++ keysTSTextObjs ++ (keymapUnlazy keysTSContext);
    plugins = {
      treesitter = {
        grammarPackages = lib.filter (i:
          lib.elem i.pname (map (p: "tree-sitter-${p}") [
            "bash"
            "bibtex"
            "c"
            "css"
            "csv"
            "diff"
            "dockerfile"
            "git_config"
            "git_rebase"
            "gitattributes"
            "gitcommit"
            "gitignore"
            "go"
            "gomod"
            "gosum"
            "gotmpl"
            "haskell"
            "hcl"
            "helm"
            "html"
            "http"
            "ini"
            "java"
            "javascript"
            "jq"
            "json"
            "kdl"
            "latex"
            "ledger"
            "lua"
            "make"
            "markdown"
            "markdown_inline"
            "mermaid"
            "nginx"
            "nix"
            "nu"
            "php"
            "python"
            "promql"
            "query"
            "regex"
            "rust"
            "scss"
            "terraform"
            "toml"
            "tsx"
            "typescript"
            "vim"
            "vimdoc"
            "xml"
            "yaml"
            "zig"
          ]))
        config.plugins.treesitter.package.allGrammars;
        languageRegister = {
          markdown = [
            "vimwiki"
          ];
          terraform = [
            "terraform-vars"
          ];
        };
      };
      treesitter-context = {
        enable = true;
        lazyLoad.settings = {
          event = ["BufReadPost" "BufNewFile"];
          keys = keymap2Lazy keysTSContext;
        };
        settings = {
          enable = false;
          max_line = 4;
          min_window_height = 40;
          multiwindow = true;
          separator = "~";
        };
      };
      treesitter-textobjects = {
        enable = true;
        settings = {
          move.set_jumps = true;
          select = {
            lookahead = true;
            include_surrounding_whitespace = false;
            selection_modes = {
              "@parameter.outer" = "v";
              "@function.outer" = "V";
              "@class.outer" = "<c-v>";
            };
          };
        };
      };
    };
  };
}
