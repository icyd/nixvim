{ pkgs, ...}: {
  extraPackages = with pkgs; [
    clang-tools
    go
    gotools
    haskellPackages.fourmolu
    jq
    texlivePackages.latexindent
    stylua
    nixfmt-rfc-style
    rustfmt
    shellcheck
    opentofu
    terragrunt
    codespell
  ] ++ (with pkgs.python312Packages; [
    black
    isort
  ]);
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
          nix = [ "nixfmt" ];
          python = [ "black" "isort" ];
          rust = [ "rustfmt" ];
          sh = [ "shellcheck" ];
          terraform = [ "tofu_fmt" ];
          terragrunt = [ "terragrunt_hclfmt" ];
          "*" = [ "codespell" ];
          "_" = [ "trim_whitespace" "trim_newlines" "squeeze_blanks" ];
        };
      };
    };
  };
}
