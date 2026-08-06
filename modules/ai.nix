{
  flake.modules.nixvim.codecompanion = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.plugins.codecompanion;
    inherit (config.utils.mkKey) mkKeyMap mkKeyMapIf wKeyObjMapIf keymap2Lazy keymapUnlazy;
    keysCodecompanion = mkKeyMapIf config.plugins.codecompanion.enable [
      {
        action = "<cmd>CodeCompanionChat Toggle<CR>";
        key = "<leader>ait";
        options.desc = "CodeCompanion chat toggle";
      }
      {
        action = "<cmd>CodeCompanionChat<CR>";
        key = "<leader>aic";
        options.desc = "CodeCompanion new chat";
      }
      {
        mode = ["n" "v"];
        action = "<cmd>CodeCompanionActions<CR>";
        key = "<leader>aia";
        options.desc = "CodeCompanion actions";
      }
      {
        mode = ["v"];
        action = "<cmd>CodeCompanionAdd<CR>";
        key = "<leader>ail";
        options.desc = "CodeCompanion add to chat";
      }
      {
        mode = ["v"];
        action = "<cmd>CodeCompanion<CR>";
        key = "<leader>aii";
        options.desc = "CodeCompanion inline";
      }
      {
        mode = ["n" "v"];
        action.__raw = ''function() return require("codecompanion").cli({prompt = true}) end'';
        key = "<leader>aiC";
        options.desc = "CodeCompanion CLI prompt";
      }
      {
        action = "<cmd>CodeCompanion /commit<CR>";
        key = "<leader>aiq";
        options.desc = "CodeCompanion quick commit";
      }
    ];
    keysGitlab = mkKeyMapIf config.plugins.gitlab.enable [
      {
        action = "<Plug>(GitLabToggleCodeSuggestions)<CR>";
        key = "<leader>aig";
        options.desc = "GitLab toggle code suggestions";
      }
    ];
  in {
    keymaps = keymapUnlazy (keysCodecompanion ++ keysGitlab);
    plugins = {
      codecompanion = {
        enable = true;
        lazyLoad.settings = {
          before.__raw = ''
            function()
              require("lz.n").trigger_load("mcp-companion-nvim")
              require("lz.n").trigger_load("codecompanion-history.nvim")
            end
          '';
          cmd = [
            "CodeCompanion"
            "CodeCompanionChat"
            "CodeCompanionCLI"
            "CodeCompanionCmd"
            "CodeCompanionActions"
            "CodeCompanionAdd"
          ];
          keys = keymap2Lazy keysCodecompanion;
        };
        settings = {
          opts = {
            language = "English";
            system_prompt = "";
          };
          extensions = {
            history = {
              enable = true;
              opts = {
                picker = "snacks";
              };
            };
            mcp_companion = lib.mkIf config.plugins.mcp-companion.enable {
              callback = "mcp_companion.cc";
            };
            spinner.opts.style =
              if config.plugins.fidget.enable
              then "fidget"
              else "snacks";
          };
        };
      };
      codecompanion-history = {
        enable = true;
        lazyLoad.settings = {
          lazy = true;
        };
      };
      codecompanion-picker = {
        enable = config.plugins.snacks.enable && config.plugins.snacks.settings.picker.enabled;
        settings = {
          picker = "snacks";
        };
        lazyLoad.settings = {
          cmd = [
            "CodeCompanionPrompts"
            "CodeCompanionSkills"
          ];
          keys = keymap2Lazy (mkKeyMap [
            {
              action = "<cmd>CodeCompanionPrompts<CR>";
              key = "<leader>aiP";
              options.desc = "CodeCompanion prompts picker";
            }
          ]);
        };
      };
      codecompanion-spinners.enable = true;
      mcp-companion = {
        enable = true;
        lazyLoad.settings = {
          cmd = [
            "MCPStatus"
            "MCPLog"
            "MCPReload"
            "MCPRestart"
            "MCPRestartServer"
            "MCPToggleServer"
            "MCPSaveProjectConfig"
          ];
          before.__raw = ''
            function()
              require("lz.n").trigger_load("sharedserver-nvim")
            end
          '';
        };
        settings = {
          combiner = {
            command = "${lib.getExe pkgs.mcp-combiner-bin}";
            host = "192.168.1.131";
            port = 9741;
            config.__raw = ''vim.fn.expand("~/.config/mcp-combiner/servers.json")'';
          };
          native_servers = {
            neovim = {
              enable = true;
              auto_approve = ["tier:read" "tier:navigate" "edit_buffer"];
            };
          };
        };
      };
      sharedserver = {
        enable = true;
        settings.sharedserver_cmd = "${lib.getExe pkgs.sharedserver}";
        lazyLoad.settings.lazy = true;
      };
      gitlab = {
        enable = true;
        package = pkgs.local.gitlab-ls;
        lazyLoad.settings = {
          cmd = [
            "GitLabCodeSuggestionsStart"
          ];
          keys = keymap2Lazy keysGitlab;
        };
        settings = {
          code_suggestions = {
            # auto_filetypes = ["lua"];
            ghost_text = {
              enabled = true;
              stream = true;
              toggle_enabled = "<C-g>t";
              accept_suggestion = "<C-g>y";
              clear_suggestion = "<C-g>e";
            };
            lsp_binary_path = lib.getExe pkgs.nodejs;
          };
          statusline.enable = false;
          minimal_message_level.__raw = "vim.lsp.log_levels.INFO";
          fix_newlines = false;
        };
      };
      vectorcode = {
        enable = false;
      };
    };
    utils.wKeyList = wKeyObjMapIf cfg.enable [
      ["<leader>ai" "" "AI"]
    ];
  };
}
