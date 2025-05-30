{
  lib,
  pkgs,
  helpers,
  ...
}: let
  inherit (lib.nixvim.utils) mkRaw;
in {
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
        format_on_save = mkRaw ''
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
          markdown = ["prettier" "markdownlint-cli2"];
          python = ["black" "isort"];
          rust = ["rustfmt"];
          sh = ["shellcheck"];
          terraform = ["tofu_fmt"];
          terragrunt = ["terragrunt_hclfmt"];
          "*" = ["codespell"];
          "_" = ["trim_whitespace" "trim_newlines" "squeeze_blanks"];
        };
        formatters = {
          alejandra.command = lib.getExe pkgs.alejandra;
          black.command = lib.getExe pkgs.black;
          clang-format.command = lib.getExe' pkgs.clang-tools "clang-format";
          codespell.command = lib.getExe pkgs.codespell;
          fourmolu.command = lib.getExe pkgs.haskellPackages.fourmolu;
          gofmt.command = lib.getExe' pkgs.go "gofmt";
          goimports.command = lib.getExe' pkgs.gotools "goimports";
          isort.command = lib.getExe pkgs.isort;
          jq.command = lib.getExe pkgs.jq;
          latexindent.command = lib.getExe' pkgs.texlivePackages.latexindent "latexindent";
          markdownlint-cli2 = {
            command = lib.getExe pkgs.markdownlint-cli2;
            condition = helpers.mkRaw ''
              function(_, ctx)
                local diag = vim.tbl_filter(function(d)
                  return d.source == "markdownlint"
                end, vim.diagnostic.get(ctx.buf))
                return #diag > 0
              end
            '';
          };
          prettier.command = lib.getExe pkgs.nodePackages.prettier;
          rustfmt.command = lib.getExe pkgs.rustfmt;
          shellcheck.command = lib.getExe pkgs.shellcheck;
          squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
          stylua.command = lib.getExe pkgs.stylua;
          terragrunt_hclfmt.command = lib.getExe pkgs.terragrunt;
          tofu_fmt.command = lib.getExe pkgs.opentofu;
        };
      };
    };
  };
  extraConfigLuaPre = ''
    local format_status = function(args)
      local status = "enabled"
      local type = "globally"

      if args.bang then
        type = "for buffer"
        if vim.b.disable_autoformat then
          msg = "disabled"
        end
      else
        if vim.g.disable_autoformat then
          msg = "disabled"
        end
      end

      print("Format is " .. status .. " " .. type)
    end
  '';
  userCommands = {
    FormatStatus = {
      bang = true;
      command.__raw = "format_status";
      desc = "Get status of format";
    };
    FormatDisable = {
      bang = true;
      command = mkRaw ''
        function(args)
          if args.bang then
            vim.b.disable_autoformat = true
          else
            vim.g.disable_autoformat = true
          end
          format_status(args)
        end
      '';
      desc = "Disable auto format on save";
    };
    FormatEnable = {
      bang = true;
      command = mkRaw ''
        function(args)
          if args.bang then
            vim.b.disable_autoformat = false
          else
            vim.g.disable_autoformat = false
          end
          format_status(args)
        end
      '';
      desc = "Enable auto format on save";
    };
    FormatToggle = {
      bang = true;
      command = mkRaw ''
        function(args)
          if args.bang then
            vim.b.disable_autoformat = not vim.b.disable_autoformat
          else
            vim.g.disable_autoformat = not vim.g.disable_autoformat
          end
          format_status(args)
        end
      '';
      desc = "Toggle auto format on save";
    };
  };
}
