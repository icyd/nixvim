{
  flake.modules.nixvim.lsp = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) getExe getExe';
    inherit (lib.nixvim.utils) mkRaw;
  in {
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
        linters = with pkgs; {
          chktex.cmd = getExe' texlivePackages.chktex "chktex";
          clangtidy.cmd = getExe' clang-tools "clang-tidy";
          flake8.cmd = getExe python312Packages.flake8;
          golangcilint.cmd = getExe golangci-lint;
          hadolint.cmd = getExe hadolint;
          hlint.cmd = getExe hlint;
          jsonlint.cmd = getExe nodePackages.jsonlint;
          luacheck.cmd = getExe luajitPackages.luacheck;
          mypy.cmd = getExe mypy;
          pylint.cmd = getExe pylint;
          shellcheck.cmd = getExe shellcheck;
          stylelint.cmd = getExe stylelint;
          yamllint.cmd = getExe yamllint;
        };
        # FIX: cannot use `markdownlint-cli2` with regular config <25-05-07>
        luaConfig.post = ''
          __lint.linters["markdownlint-cli2"].cmd = "${getExe pkgs.markdownlint-cli2}"
        '';
      };
    };
    userCommands = {
      LintInfo = {
        command = mkRaw ''
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
  };
}
