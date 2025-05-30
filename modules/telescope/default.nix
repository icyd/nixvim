{
  lib,
  config,
  ...
}: let
  inherit (config.my.mkKey) wKeyObj;
  inherit (lib.nixvim.utils) mkRaw;
in {
  keymaps = lib.mkIf config.plugins.telescope.enable [
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
          require("telescope.builtin").find_files({
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
  ];
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
        "<leader>ff" = "find_files";
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
      };
    };
    web-devicons.enable = true;
  };
  my.wKeyList = lib.optionals config.plugins.telescope.enable [
    (wKeyObj ["<leader>f" "" "Telescope"])
    (wKeyObj ["<localleader>f" "" "Telescope"])
  ];
}
