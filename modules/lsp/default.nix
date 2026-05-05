{
  flake.modules.nixvim.lsp = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap wKeyObjMapIf keymap2Lazy keymapUnlazy;
    rustAnalyzerSettings = {
      cargo = {
        buildScripts.enable = true;
        features = "all";
      };
      checkOnSave = true;
      check = {
        command = "clippy";
        features = "all";
      };
      diagnostics = {
        enable = true;
        styleLints.enable = true;
      };
      files.excludeDirs = [".git" ".cargo" ".direnv" "target" "node_modules"];
      inlayHints = {
        bindingModeHints.enable = true;
        closureStyle = "rust_analyzer";
        closureReturnTypeHints.enable = true;
        closureCaptureHints.enable = true;
        lifetimeElisionHints.enable = "always";
        discriminantHints.enable = "always";
        expressionAdjustmentHints.enable = "always";
        implicitDrops.enable = true;
        rangeExclusiveHints.enable = true;
      };
      procMacro.enable = true;
      rustc.source = "discover";
    };
    keysNavBuddy = mkKeyMap [
      {
        action = "<cmd>Navbuddy<CR>";
        key = "<leader>xn";
        options.desc = "Navbuddy toggle";
      }
    ];
  in {
    keymaps = keymapUnlazy keysNavBuddy;
    plugins = {
      crates.enable = true;
      fidget.enable = true;
      inc-rename = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings = {
          input_buffer_type = lib.mkIf config.plugins.snacks.enable "snacks";
        };
      };
      lsp = {
        enable = true;
        inlayHints = true;
        keymaps = {
          extra = mkKeyMap [
            {
              action.__raw = ''
                function()
                  if pcall(require, "inc_rename") then
                    return ":IncRename " .. vim.fn.expand("<cword>")
                  end

                  vim.lsp.buf.rename()
                end
              '';
              key = "<leader>lr";
              options.desc = "Lsp buf rename";
              options.expr = true;
            }
            {
              action = "<cmd>LspRestart<CR>";
              key = "<leader>lR";
              options.desc = "Lsp restart";
            }
            {
              action.__raw = ''
                function()
                  vim.lsp.buf.format({ async = true })
                end
              '';
              key = "<leader>lF";
              options.desc = "Lsp buf async format";
            }
            {
              action.__raw = ''
                function()
                  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}),{0})
                end
              '';
              key = "<leader>lh";
              options.desc = "Toggle Lsp inlay hints";
            }
          ];
          diagnostic = {
            "<leader>lq" = "setqflist";
            "<leader>ll" = "setloclist";
            "<leader>lg" = "open_float";
          };
          lspBuf = {
            K = "hover";
            gd = "definition";
            gD = "references";
            gi = "implementation";
            gt = "type_definition";
            "<leader>la" = "code_action";
            "<leader>ld" = "document_symbol";
            "<leader>lD" = "workspace_symbol";
          };
        };
        luaConfig.pre = ''
          local function rename()
              if pcall(require, "inc_rename") then
                  return ":IncRename " .. vim.fn.expand("<cword>")
              end

              vim.lsp.buf.rename()
          end
        '';
        servers = {
          bashls = {
            enable = true;
            package = pkgs.bash-language-server;
          };
          clangd = {
            enable = true;
            package = pkgs.clang-tools;
            packageFallback = true;
          };
          dockerls = {
            enable = true;
            package = pkgs.dockerfile-language-server;
          };
          gitlab_ci_ls = {
            enable = true;
            package = pkgs.gitlab-ci-ls;
          };
          gopls = {
            enable = true;
            package = pkgs.gopls;
            packageFallback = true;
          };
          jsonls = {
            enable = true;
            package = pkgs.vscode-langservers-extracted;
          };
          helm_ls = {
            enable = true;
            package = pkgs.helm-ls;
            extraOptions.settings.__raw = ''
              {
                ["helm-ls"] = {
                  yamlls = {
                    enabled = false,
                    path = "${lib.getExe pkgs.yaml-language-server}",
                  }
                }
              }
            '';
          };
          emmylua_ls.enable = true;
          nixd = {
            enable = true;
            package = pkgs.nixd;
            packageFallback = true;
          };
          nushell = {
            enable = true;
            package = null;
          };
          openscad_lsp = {
            enable = true;
            package = pkgs.openscad-lsp;
          };
          pylsp = {
            enable = true;
            package = pkgs.python3Packages.python-lsp-server;
            packageFallback = true;
          };
          ruff = {
            enable = true;
            package = pkgs.ruff;
            packageFallback = true;
          };
          rust_analyzer = {
            enable = !config.plugins.rustaceanvim.enable;
            settings = rustAnalyzerSettings;
            installCargo = false;
            installRustc = false;
            installRustfmt = false;
            package = null;
            # packageFallback = true;
          };
          terraformls = {
            enable = true;
            package = pkgs.terraform-ls;
            packageFallback = true;
          };
          ts_ls.enable = !config.plugins.typescript-tools.enable;
          yamlls = {
            enable = true;
            package = pkgs.yaml-language-server;
          };
        };
      };
      lspkind = {
        enable = config.plugins.blink-cmp.enable && config.plugins.lsp.enable;
        settings = {
          mode = "symbol_text";
          cmp = {
            max_width = 50;
            ellipsis_char = "...";
          };
          show_labelDetails = true;
        };
      };
      navbuddy = {
        enable = true;
        lazyLoad.settings.keys = keymap2Lazy keysNavBuddy;
        settings.lsp.auto_attach = true;
      };
      navic = {
        enable = true;
        lazyLoad.settings.event = [
          "BufReadPost"
          "BufNewFile"
        ];
        settings.lsp.auto_attach = true;
      };
      rustaceanvim = {
        enable = true;
        settings = {
          server.default_settings.rust-analyzer = rustAnalyzerSettings;
        };
      };
      schemastore.enable = true;
      typescript-tools.enable = true;
    };
    utils.wKeyList = wKeyObjMapIf config.plugins.telescope.enable [
      ["<leader>l" "" "Lsp"]
    ];
  };
}
