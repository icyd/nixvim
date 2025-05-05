{
  lib,
  config,
  helpers,
  pkgs,
  ...
}: let
  inherit (config.my.mkKey) mkKeyMap wKeyObj;
in {
  extraPlugins = with pkgs;
    [
      helm-ls
    ]
    ++ (with pkgs.vimPlugins; [
      haskell-tools-nvim
    ]);
  globals = {
    haskell_tools.tools.repl.handler = lib.mkIf config.plugins.toggleterm.enable "toggleterm";
  };
  keymaps = builtins.map mkKeyMap [
    {
      action = "<cmd>Navbuddy<CR>";
      key = "<leader>xn";
      mode = "n";
      options.desc = "Navbuddy toggle";
    }
    {
      action.__raw = ''
        function()
          require("otter").activate()
        end
      '';
      key = "<leader>lO";
      mode = "n";
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
        extra = [
          {
            action.__raw = ''
              function()
                vim.lsp.diagnostic.jump({ count = -1 })
              end
            '';
            key = "[d";
            mode = "n";
            options.desc = "Lsp diagnostic goto previous";
          }
          {
            action.__raw = ''
              function()
                vim.lsp.diagnostic.jump({ count = 1 })
              end
            '';
            key = "]d";
            mode = "n";
            options.desc = "Lsp diagnostic goto next";
          }
          {
            action.__raw = "rename";
            key = "<leader>lr";
            mode = "n";
            options.desc = "Lsp buf rename";
            options.expr = true;
          }
          {
            action = "<cmd>LspRestart<CR>";
            key = "<leader>lR";
            mode = "n";
            options.desc = "Lsp restart";
          }
          {
            action.__raw = ''
              function()
                vim.lsp.buf.format({ async = true })
              end
            '';
            key = "<leader>lF";
            mode = "n";
            options.desc = "Lsp buf async format";
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
          extraOptions.settings = helpers.mkRaw ''            {
                        ["helm-ls"] = {
                          yamlls = {
                            path = "yaml-language-server"
                          }
                        }
                      }'';
        };
        html.enable = true;
        lemminx.enable = true;
        ltex = {
          enable = true;
          settings = {
            additionalRules.languageModel = "~/.local/share/nvim/models/ngrams/";
            enabled = [
              "bibtex"
              "context"
              "context.tex"
              "html"
              "latex"
              "markdown"
              "neorg"
              "norg"
              "org"
              "restructuredtext"
              "rsweave"
            ];
            language = "en-GB";
          };
        };
        lua_ls.enable = true;
        nixd.enable = true;
        nushell.enable = true;
        pylsp.enable = true;
        rust_analyzer.enable = !config.plugins.rustaceanvim.enable;
        terraformls.enable = true;
        yamlls.enable = true;
        zls.enable = true;
      };
    };
    crates.enable = true;
    rustaceanvim.enable = true;
    navic = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      settings.lsp.auto_attach = true;
    };
    navbuddy = {
      enable = true;
      lsp.autoAttach = true;
    };
  };
  my.wKeyList = lib.optionals config.plugins.telescope.enable [
    (wKeyObj ["<leader>l" "" "Lsp"])
  ];
  imports = with builtins;
    map (fn: ./${fn})
    (filter
      (fn: (
        fn != "default.nix"
      ))
      (attrNames (readDir ./.)));
}
