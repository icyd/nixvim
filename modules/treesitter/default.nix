{pkgs, ...}: {
  plugins = {
    ts-comments = {
      enable = true;
      lazyLoad.settings.event = "BufReadPre";
    };
    treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        awk
        bash
        bibtex
        c
        c_sharp
        cmake
        comment
        commonlisp
        cpp
        css
        csv
        diff
        dockerfile
        dot
        editorconfig
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        go
        gomod
        gosum
        gpg
        graphql
        groovy
        haskell
        hcl
        helm
        html
        http
        hyprlang
        ini
        java
        javascript
        jq
        json
        json5
        jsonc
        jsonnet
        latex
        ledger
        lua
        luadoc
        luap
        luau
        make
        markdown
        markdown_inline
        nginx
        nix
        norg
        nu
        org
        perl
        php
        proto
        python
        regex
        rego
        ruby
        rust
        scss
        terraform
        toml
        tsv
        tsx
        typescript
        vim
        vimdoc
        xml
        yaml
        zig
      ];
      settings = {
        highlight.enable = true;
      };
    };
    treesitter-refactor.enable = true;
    treesitter-textobjects = {
      enable = true;
      move = {
        enable = true;
        setJumps = true;
        gotoNextStart = {
          "]m" = {
            desc = "Go to next start of function with Treesitter";
            query = "@function.outer";
          };
          "]]" = {
            desc = "Go to next start of class with Treesitter";
            query = "@class.outer";
          };
        };
        gotoNextEnd = {
          "]M" = {
            desc = "Go to next end of function with Treesitter";
            query = "@function.outer";
          };
          "][" = {
            desc = "Go to next end of class with Treesitter";
            query = "@class.outer";
          };
        };
        gotoPreviousStart = {
          "[m" = {
            desc = "Go to previous start of function with Treesitter";
            query = "@function.outer";
          };
          "[]" = {
            desc = "Go to previous start of class with Treesitter";
            query = "@class.outer";
          };
        };
        gotoPreviousEnd = {
          "[M" = {
            desc = "Go to previous end of function with Treesitter";
            query = "@function.outer";
          };
          "[[" = {
            desc = "Go to previous end of class with Treesitter";
            query = "@class.outer";
          };
        };
      };
      select = {
        enable = true;
        lookahead = true;
        keymaps = {
          "af" = {
            desc = "Select outer function with Treesitter";
            query = "@function.outer";
          };
          "if" = {
            desc = "Select inner function with Treesitter";
            query = "@function.inner";
          };
          "ac" = {
            desc = "Select class with Treesitter";
            query = "@class.outer";
          };
          "ic" = {
            desc = "Select inner part of class region with Treesitter";
            query = "@class.inner";
          };
        };
        selectionModes = {
          "@parameter.outer" = "v";
          "@function.outer" = "V";
          "@class.outer" = "<c-v>";
        };
      };
      swap = {
        enable = true;
        swapNext = {
          "<leader>xp" = {
            desc = "Swap next parameter";
            query = "@parameter.inner";
          };
          "<leader>xf" = {
            desc = "Swap next function";
            query = "@function.outer";
          };
          "<leader>xc" = {
            desc = "Swap next class";
            query = "@class.outer";
          };
        };
        swapPrevious = {
          "<leader>xP" = {
            desc = "Swap previous parameter";
            query = "@parameter.inner";
          };
          "<leader>xF" = {
            desc = "Swap previous function";
            query = "@function.outer";
          };
          "<leader>xC" = {
            desc = "Swap previous class";
            query = "@class.outer";
          };
        };
      };
    };
  };
}
