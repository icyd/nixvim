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
          # css = ["stylelint"];
          dockerfile = ["hadolint"];
          go = ["revive"];
          # haskell = ["hlint"];
          # json = ["jsonlint"];
          latex = ["chktex"];
          lua = ["luacheck"];
          markdown = ["markdownlint-cli2"];
          nix = ["nix"];
          python = ["ruff"];
          sh = ["shellcheck"];
          yaml = ["yamllint"];
        };
        linters = with pkgs; {
          chktex.cmd = getExe' texlivePackages.chktex "chktex";
          clangtidy.cmd = getExe' clang-tools "clang-tidy";
          # flake8.cmd = getExe python312Packages.flake8;
          hadolint.cmd = getExe hadolint;
          # hlint.cmd = getExe hlint;
          # jsonlint.cmd = getExe nodePackages.jsonlint;
          luacheck.cmd = getExe luajitPackages.luacheck;
          # mypy.cmd = getExe mypy;
          # pylint.cmd = getExe pylint;
          # pyrefly = {
          #   cmd = getExe pyrefly;
          #   stdin = true;
          #   stream = "stdout";
          #   ignore_exitcode = true;
          #   args = [
          #     "check"
          #     "output-format"
          #     "json"
          #   ];
          #   parser.__raw = ''
          #     function(output)
          #         ---@type nvim-lint.pyrefly.diagnostics
          #         local json_data = vim.json.decode(output)
          #
          #         local severities = {
          #           ERROR = vim.diagnostic.severity.ERROR,
          #           WARN = vim.diagnostic.severity.WARN,
          #           INFO = vim.diagnostic.severity.HINT,
          #         }
          #
          #         local diagnostics = {}
          #
          #         for _, error in ipairs(json_data.errors) do
          #           table.insert(diagnostics, {
          #             source = "pyrefly",
          #             lnum = error.line - 1,
          #             col = error.column - 1,
          #             end_lnum = error.stop_line - 1,
          #             end_col = error.stop_column,
          #             severity = severities[error.severity],
          #             message = error.description,
          #             code = error.name,
          #           })
          #         end
          #         return diagnostics
          #       end
          #   '';
          # };
          revive.cmd = getExe revive;
          ruff.cmd = getExe ruff;
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
