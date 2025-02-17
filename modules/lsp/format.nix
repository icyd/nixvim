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
}
