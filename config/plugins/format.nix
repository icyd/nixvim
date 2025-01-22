{
  plugins = {
    conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = rec {
          c = [ "clang-format" ];
          cpp = c;
          go = [ "gofmt" "goimports" ];
          haskell = [ "fourmolu" ];
          json = [ "jq" ];
          latex = [ "latexindent" ];
          lua = [ "stylua" ];
          # nix = [ "nixfmt" ];
          python = [ "black" "isort" ];
          rust = [ "rustfmt" ];
          sh = [ "shellcheck" ];
          terraform = [ "terraform_fmt" ];
          "*" = [ "codespell" ];
          "_" = [ "trim_whitespace" "trim_newlines" "squeeze_blanks" ];
        };
      };
    };
  };
}
