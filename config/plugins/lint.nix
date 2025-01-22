{
  plugins = {
    lint = {
      enable = true;
      lintersByFt = rec {
        c = [ "clangtidy" ];
        cpp = c;
        css = [ "stylelint" ];
        dockerfile = [ "hadolint" ];
        go = [ "golangcilint" ];
        haskell = [ "hlint" ];
        json = [ "jsonlint" ];
        latex = [ "chktex" ];
        lua = [ "luacheck" ];
        markdown = [ "vale" ];
        nix = [ "nix" ];
        python = [ "mypy" "flake8" "pylint" ];
        sh = [ "shellcheck" ];
        yaml = [ "yamllint" ];
      };
    };
  };
}
