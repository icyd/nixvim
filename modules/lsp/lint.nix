{
  flake.modules.nixvim.lsp = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) getExe getExe';
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
          bash = ["shellcheck"];
          c = ["clangtidy"];
          cpp = c;
          dockerfile = ["hadolint"];
          go = ["revive"];
          latex = ["chktex"];
          lua = ["luacheck"];
          markdown = ["markdownlint-cli2"];
          nix = ["deadnix" "nix"];
          python = ["ruff"];
          sh = bash;
          yaml = ["yamllint"];
        };
        linters = with pkgs; {
          chktex.cmd = getExe' texlivePackages.chktex "chktex";
          clangtidy.cmd = getExe' clang-tools "clang-tidy";
          deadnix.cmd = getExe deadnix;
          hadolint.cmd = getExe hadolint;
          luacheck.cmd = getExe luajitPackages.luacheck;
          markdownlint-cli2.cmd = getExe markdownlint-cli2;
          revive.cmd = getExe revive;
          ruff.cmd = getExe ruff;
          shellcheck.cmd = getExe shellcheck;
          stylelint.cmd = getExe stylelint;
          yamllint.cmd = getExe yamllint;
        };
        # FIX: cannot use `markdownlint-cli2` with regular config <25-05-07>
        # luaConfig.post = ''
        #   __lint.linters["markdownlint-cli2"].cmd = "${getExe pkgs.markdownlint-cli2}"
        # '';
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
  };
}
