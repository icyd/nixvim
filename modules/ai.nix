{
  flake.modules.nixvim.codecompanion = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.plugins.codecompanion;
    inherit (config.utils.mkKey) mkKeyMapIf wKeyObjMapIf keymap2Lazy keymapUnlazy;
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
        key = "<leader>aip";
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
        action.__raw = ''function() return require("codecompation").cli({prompt = true}) end'';
        key = "<leader>aip";
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
    extraPlugins = with pkgs; [
      local.codecompanion-spinners
    ];
    plugins = {
      codecompanion = {
        enable = true;
        lazyLoad.settings = {
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
          # display.chat.show_settings = true;
          extensions = {
            spinner.opts.style =
              if config.plugins.fidget.enable
              then "fidget"
              else "snacks";
          };
          adapters = let
            copilot_gpt5_4.__raw = ''
              function()
                return require("codecompanion.adapters").extend("copilot", {
                  schema = {
                    model = { default = "gpt-5.4" },
                    max_tokens = { default = 4096 },
                  }
                })
              end
            '';
            copilot_sonnet4_6.__raw = ''
              function()
                return require("codecompanion.adapters").extend("copilot", {
                  schema = {
                    model = { default = "claude-sonnet-4.6" },
                  }
                })
              end
            '';
            copilot_gpt5_mini.__raw = ''
              function()
                return require("codecompanion.adapters").extend("copilot", {
                  schema = {
                    model = { default = "gpt-5-mini" },
                  }
                })
              end
            '';
          in {
            http = {
              inherit copilot_gpt5_4 copilot_sonnet4_6 copilot_gpt5_mini;
            };
          };
          interactions = {
            chat = {
              adapter = "copilot_sonnet4_6";
            };
            cli = {
              agent = "opencode";
              agents = {
                opencode = {
                  cmd = "opencode";
                  args = {};
                  description = "Opencode interactive terminal";
                  provider = "terminal";
                };
              };
            };
            cmd.adapter = "copilot_gpt5_mini";
            inline.adapter = "copilot_gpt5_mini";
          };
        };
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
    };
    utils.wKeyList = wKeyObjMapIf cfg.enable [
      ["<leader>ai" "" "AI"]
    ];
  };
}
