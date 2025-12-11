{
  flake.modules.nixvim.lsp = {
    lib,
    config,
    pkgs,
    ...
  }: let
    # inherit (config.utils.mkKey) mkKeyMap wKeyObj;
    inherit (config.utils.mkKey) mkKeyMap;
    inherit (lib.nixvim.utils) mkRaw;
    rustAnalyzerSettings = {
      check.command = "clippy";
      files.exclude = [".git" ".cargo" ".direnv" "target"];
      inlayHints = {
        lifetimeElisionHints.enable = "always";
        bindingModeHints.enable = true;
        closureCaptureHints.enable = true;
      };
    };
  in {
    # extraPackages = with pkgs; [
    #   cargo-nextest
    # ];
    extraPlugins = with pkgs.vimPlugins; [
      haskell-tools-nvim
    ];
    globals = {
      haskell_tools.tools.repl.handler = lib.mkIf config.plugins.toggleterm.enable "toggleterm";
    };
    keymaps = builtins.map mkKeyMap [
      {
        action = "<cmd>Navbuddy<CR>";
        key = "<leader>xn";
        options.desc = "Navbuddy toggle";
      }
      {
        action = mkRaw ''
          function()
            require("otter").activate()
          end
        '';
        key = "<leader>lO";
        options.desc = "Activate Otter";
      }
    ];
    plugins = {
      fidget.enable = true;
      inc-rename.enable = true;
      lsp = {
        enable = true;
        inlayHints = true;
        keymaps = {
          extra = builtins.map mkKeyMap [
            {
              action = mkRaw "rename";
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
              action = mkRaw ''
                function()
                  vim.lsp.buf.format({ async = true })
                end
              '';
              key = "<leader>lF";
              options.desc = "Lsp buf async format";
            }
            {
              action = mkRaw ''
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
          bashls.enable = true;
          clangd.enable = true;
          cssls.enable = true;
          dockerls.enable = true;
          gopls.enable = true;
          jdtls.enable = true;
          jsonls.enable = true;
          helm_ls = {
            enable = true;
            extraOptions.settings = mkRaw ''
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
          html.enable = true;
          lemminx.enable = true;
          ltex_plus = {
            enable = true;
            package = pkgs.ltex-ls-plus;
            extraOptions.settings = {
              additionalRules.languageModel = "~/.local/share/nvim/models/ngrams/";
              language = "en";
            };
          };
          lua_ls.enable = true;
          marksman.enable = true;
          nixd.enable = true;
          nushell = {
            enable = true;
            package = null;
          };
          pylsp.enable = true;
          rust_analyzer = {
            # enable = !config.plugins.rustaceanvim.enable;
            enable = true;
            settings = rustAnalyzerSettings;
            installCargo = false;
            installRustc = false;
            installRustfmt = false;
            package = null;
          };
          terraformls.enable = true;
          ts_ls.enable = !config.plugins.typescript-tools.enable;
          yamlls.enable = true;
          zls = {
            enable = true;
            package = null;
          };
        };
      };
      crates.enable = true;
      rustaceanvim = {
        enable = false;
        settings.server.default_settings.rust-analyzer = rustAnalyzerSettings;
      };
      navic = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings.lsp.auto_attach = true;
      };
      navbuddy = {
        enable = true;
        settings.lsp.auto_attach = true;
      };
      typescript-tools.enable = true;
    };
    # utils.wKeyList = lib.optionals config.plugins.telescope.enable [
    #   (wKeyObj ["<leader>l" "" "Lsp"])
    # ];
  };
}
