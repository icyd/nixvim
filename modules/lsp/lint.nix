{
  lib,
  pkgs,
  ...
}: {
  plugins = {
    lint = {
      enable = true;
      lazyLoad.settings.event = [
        "BufWritePost"
        "BufReadPost"
        "InsertLeave"
      ];
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
        markdown = ["markdownlint-cli2"];
        nix = ["nix"];
        python = ["mypy" "flake8" "pylint"];
        sh = ["shellcheck"];
        yaml = ["yamllint"];
      };
      linters = {
        chktex.cmd = lib.getExe' pkgs.texlivePackages.chktex "chktex";
        clangtidy.cmd = lib.getExe' pkgs.clang-tools "clang-tidy";
        flake8.cmd = lib.getExe pkgs.python312Packages.flake8;
        golangcilint.cmd = lib.getExe pkgs.golangci-lint;
        hadolint.cmd = lib.getExe pkgs.hadolint;
        hlint.cmd = lib.getExe pkgs.hlint;
        jsonlint.cmd = lib.getExe pkgs.nodePackages.jsonlint;
        luacheck.cmd = lib.getExe pkgs.luajitPackages.luacheck;
        mypy.cmd = lib.getExe pkgs.mypy;
        pylint.cmd = lib.getExe pkgs.pylint;
        shellcheck.cmd = lib.getExe pkgs.shellcheck;
        stylelint.cmd = lib.getExe pkgs.stylelint;
        yamllint.cmd = lib.getExe pkgs.yamllint;
      };
      # FIX: cannot use `markdownlint-cli2` with regular config <25-05-07>
      luaConfig.post = ''
        __lint.linters["markdownlint-cli2"].cmd = "${lib.getExe pkgs.markdownlint-cli2}"
      '';
    };
  };
  userCommands = {
    LintInfo = {
      command.__raw = ''
        function()
          local filetype = vim.bo.filetype
          local linters = require("lint").linters_by_ft[filetype]
          if linters then
            print("Linters for filetype: " .. filetype .. " -> " .. table.concat(linters, ", "))
          else
            print("No linters configured for filetype: " .. filetype)
          end
        end
      '';
      desc = "Display linters enabled for filetype";
    };
  };
}
