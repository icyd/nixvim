{
  flake.modules.nixvim.lsp = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) getExe getExe';
  in {
    plugins = {
      conform-nvim = {
        enable = true;
        lazyLoad.settings = {
          cmd = "ConformInfo";
          event = "BufWritePre";
        };
        settings = {
          default_format_opts.lsp_format = "fallback";
          format_on_save.__raw = ''
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end
                return { timeout_ms = 500, lsp_format = "fallback" }
            end
          '';
          formatters_by_ft = rec {
            bash = ["shellcheck" "shellharden" "shfmt"];
            c = ["clang-format"];
            cpp = c;
            go = ["gofmt" "goimports"];
            haskell = ["fourmolu"];
            json = ["jq"];
            latex = ["latexindent"];
            lua = ["stylua"];
            nix = ["alejandra"];
            nu = ["nufmt"];
            markdown = ["prettier" "markdownlint-cli2"];
            python = ["ruff_fix" "ruff_format" "ruff_organize_imports"];
            rust = ["rustfmt"];
            sh = bash;
            terraform = ["tofu_fmt"];
            terragrunt = ["terragrunt_hclfmt"];
            toml = ["taplo"];
            "*" = ["codespell"];
            "_" = ["trim_whitespace" "trim_newlines" "squeeze_blanks"];
          };
          formatters = with pkgs; {
            alejandra.command = getExe alejandra;
            clang-format.command = getExe' clang-tools "clang-format";
            codespell.command = getExe codespell;
            gofmt.command = getExe' go "gofmt";
            goimports.command = getExe' gotools "goimports";
            jq.command = getExe jq;
            latexindent.command = getExe' texlivePackages.latexindent "latexindent";
            markdownlint-cli2 = {
              command = getExe markdownlint-cli2;
              condition.__raw = ''
                function(_, ctx)
                  local diag = vim.tbl_filter(function(d)
                    return d.source == "markdownlint"
                  end, vim.diagnostic.get(ctx.buf))
                  return #diag > 0
                end
              '';
            };
            prettier.command = getExe prettier;
            ruff = getExe ruff;
            shellcheck.command = getExe shellcheck;
            shellharden.command = getExe shellharden;
            shfmt.command = getExe shfmt;
            squeeze_blanks.command = getExe' coreutils "cat";
            stylua.command = getExe stylua;
            taplo.command = getExe taplo;
            terragrunt_hclfmt.command = getExe terragrunt;
            tofu_fmt.command = getExe opentofu;
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
            status = "disabled"
          end
        else
          if vim.g.disable_autoformat then
            status = "disabled"
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
        command.__raw = ''
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
        command.__raw = ''
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
        command.__raw = ''
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
  };
}
