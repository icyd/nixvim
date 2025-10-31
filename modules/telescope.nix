{
  flake.modules.nixvim.telescope = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (config.utils.mkKey) wKeyObj mkKeyMap;
    inherit (lib.nixvim.utils) mkRaw;
  in {
    extraFiles = {
      "lua/telescope-config.lua".source = ../lua/telescope-config.lua;
    };
    keymaps = lib.mkIf config.plugins.telescope.enable (builtins.map mkKeyMap [
      {
        action = mkRaw ''
          function()
            require("telescope.builtin").buffers({
                show_all_buffers = true,
                sort_lastused = true,
                ignore_current_buffer = true,
                sort_mru = true,
            })
          end
        '';
        key = "<leader>b";
        options.desc = "Buffers";
      }
      {
        action = mkRaw ''
          function()
            require("telescope-config").project_files()
          end
        '';
        key = "<leader>ff";
        options.desc = "Find files relative to current path";
      }
      {
        action = mkRaw ''
          function()
            require("telescope.builtin").find_files({
                hidden = true,
                cwd = string.gsub(vim.fn.expand("%:p:h"), "oil://", ""),
            })
          end
        '';
        key = "<leader>fl";
        options.desc = "Find files relative to current file";
      }
      {
        action = mkRaw ''
          function()
            require('telescope.builtin').find_files({
                prompt_title = "< Dotfiles >",
                cwd = os.getenv("DOTFILES"),
                hidden = true,
            })
          end
        '';
        key = "<leader>fv";
        options.desc = "Find files relative to current file";
      }
      {
        action = mkRaw ''
          function()
            local orgmode_dir = os.getenv('ORGMODE_HOME')
            require('telescope.builtin').find_files({
                prompt_title = "< Notes >",
                cwd = orgmode_dir .. "/org",
            })
          end
        '';
        key = "<localleader>fn";
        options.desc = "Find files relative to current file";
      }
      {
        action = mkRaw ''
          function()
                  require("telescope.builtin").grep_string({ search = vim.fn.input("Grep for: ") })
          end
        '';
        key = "<leader>fS";
        options.desc = "Grep string";
      }
      {
        action = mkRaw ''
          function()
            require("telescope.builtin").grep_string({ search = vim.fn.expand([[<cword>]]) })
          end
        '';
        key = "<leader>fs";
        options.desc = "Grep current string";
      }
      {
        action = mkRaw ''
          function()
            require('telescope').extensions.file_browser.file_browser({
              hidden = true,
            })
          end
        '';
        key = "<leader>fb";
        options.desc = "File browser";
      }
      {
        action = mkRaw ''
          function()
            require('telescope').extensions.file_browser.file_browser({
              hidden = true,
              select_buffer = true,
              path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p:h'),
            })
          end
        '';
        key = "<leader>fB";
        options.desc = "File browser relative to current file";
      }
    ]);
    plugins = {
      telescope = {
        enable = true;
        lazyLoad.settings.cmd = "Telescope";
        extensions = {
          file-browser.enable = true;
          frecency = {
            enable = true;
            settings.db_safe_mode = false;
          };
          fzf-native = {
            enable = true;
            settings.case_mode = "smart_case";
          };
          manix.enable = true;
          project = {
            enable = true;
            settings = {
              base_dirs = [
                {
                  path = "~/Projects/";
                  max_depth = 3;
                }
              ];
              hidden_files = false;
            };
          };
          ui-select.enable = true;
          undo.enable = true;
        };
        keymaps = {
          # "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>f/" = "search_history";
          "<leader>f:" = "command_history";
          "<leader>fr" = "frecency";
          "<leader>fR" = "oldfiles";
          "<leader>fU" = "undo";
          # "<leader>fp" = "projects";
          "<leader>fF" = "current_buffer_fuzzy_find";
          "<localleader>fh" = "help_tags";
          "<localleader>fr" = "registers";
          "<localleader>fm" = "marks";
          "<localleader>fj" = "jumplist";
          "<localleader>fx" = "commands";
          "<localleader>fk" = "keymaps";
        };
        settings = {
          mappings = rec {
            i = {
              "<C-x>" = false;
              "<C-q>" = ''require("telescope.actions").sent_to_qlist'';
              "<C-t>" =
                if config.plugins.trouble.enable
                then ''require("trouble.sources.telescope").open''
                else "";
            };
            n = i;
          };
          pickers = let
            find_command = ["${lib.getExe pkgs.fd}" "--type" "f" "--color" "never"];
          in {
            find_files = {
              inherit find_command;
            };
            git_files = {
              find_command = find_command ++ ["--hidden" "--exclude" ".git"];
            };
          };
        };
      };
      web-devicons.enable = true;
    };
    utils.wKeyList = lib.optionals config.plugins.telescope.enable [
      (wKeyObj ["<leader>f" "" "Telescope"])
      (wKeyObj ["<localleader>f" "" "Telescope"])
    ];
  };
}
