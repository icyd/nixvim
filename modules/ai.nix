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
        mode = ["n" "v"];
        action = "<cmd>CodeCompanionAdd<CR>";
        key = "<leader>aip";
        options.desc = "CodeCompanion add to chat";
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
          cmd = [
            "CodeCompanion"
            "CodeCompanionChat"
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
          strategies = {
            chat.adapter = "copilot";
            inline.adapter = "copilot";
            agent.adapter = "copilot";
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
