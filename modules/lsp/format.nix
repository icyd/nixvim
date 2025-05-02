{
  lib,
  pkgs,
  ...
}: {
  extraPackages = with pkgs; [
    alejandra
    black
    clang-tools
    go
    gotools
    haskellPackages.fourmolu
    isort
    jq
    texlivePackages.latexindent
    stylua
    rustfmt
    shellcheck
    opentofu
    terragrunt
    codespell
  ];
  plugins = {
    conform-nvim = {
      enable = true;
      lazyLoad.settings = {
        cmd = "ConformInfo";
        event = "BufWritePre";
      };
      settings = {
        default_format_opts.lsp_format = "fallback";
        format_on_save.__raw = ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
              return { timeout_ms = 500, lsp_format = "fallback" }
          end
        '';
        formatters_by_ft = rec {
          c = ["clang-format"];
          cpp = c;
          go = ["gofmt" "goimports"];
          haskell = ["fourmolu"];
          json = ["jq"];
          latex = ["latexindent"];
          lua = ["stylua"];
          nix = ["alejandra"];
          python = ["black" "isort"];
          rust = ["rustfmt"];
          sh = ["shellcheck"];
          terraform = ["tofu_fmt"];
          terragrunt = ["terragrunt_hclfmt"];
          "*" = ["codespell"];
          "_" = ["trim_whitespace" "trim_newlines" "squeeze_blanks"];
        };
        formatters = {
          squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
        };
      };
    };
  };
  userCommands = {
    FormatDisable = {
      bang = true;
      command.__raw = ''
        function(args)
          if args.bang then
            vim.b.disable_autoformat = true
          else
            vim.g.disable_autoformat = true
          end
        end
      '';
      desc = "Disable auto format on save";
    };
    FormatEnable = {
      bang = true;
      command.__raw = ''
        function(args)
          if args.bang then
            vim.b.disable_autoformat = false
          else
            vim.g.disable_autoformat = false
          end
        end
      '';
      desc = "Enable auto format on save";
    };
    FormatToggle = {
      bang = true;
      command.__raw = ''
        function(args)
          if args.bang then
            vim.b.disable_autoformat = not vim.b.disable_autoformat
          else
            vim.g.disable_autoformat = not vim.g.disable_autoformat
          end
        end
      '';
      desc = "Toggle auto format on save";
    };
  };
}
