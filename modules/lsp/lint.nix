{pkgs, ...}: {
  extraPackages = with pkgs; [
    clang-tools
    stylelint
    hadolint
    golangci-lint
    hlint
    mypy
    nodePackages.jsonlint
    texlivePackages.chktex
    luajitPackages.luacheck
    pylint
    python312Packages.flake8
    vale
    shellcheck
    yamllint
  ];
  plugins = {
    lint = {
      enable = true;
      lazyLoad.settings.event = "BufWritePre";
      lintersByFt = rec {
        c = ["clangtidy"];
        cpp = c;
        css = ["stylelint"];
        dockerfile = ["hadolint"];
        go = ["golangcilint"];
        haskell = ["hlint"];
        json = ["jsonlint"];
        latex = ["chktex"];
        lua = ["luacheck"];
        markdown = ["vale"];
        nix = ["nix"];
        python = ["mypy" "flake8" "pylint"];
        sh = ["shellcheck"];
        yaml = ["yamllint"];
      };
    };
  };
}
