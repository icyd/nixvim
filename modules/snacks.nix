{
  flake.modules.nixvim.snacks = {
    lib,
    config,
    ...
  }: let
    inherit (lib.nixvim.utils) mkRaw;
    inherit (config.utils.mkKey) mkKeyMap;
    cfg = config.plugins.snacks;
    keymapsTerm = builtins.map mkKeyMap (lib.optionals (cfg.enable && cfg.settings.terminal.enabled) [
      {
        action = mkRaw ''
          function()
            require("snacks").terminal.toggle()
          end
        '';
        key = "<leader>'";
        options.desc = "Toggle Terminal";
      }
    ]);
    keymapsBufDel = builtins.map mkKeyMap (lib.optionals (cfg.enable && cfg.settings.bufdelete.enabled) [
      {
        action = mkRaw ''
          function()
            require("snacks").bufdelete.delete()
          end
        '';
        key = "<localleader>q";
        options.desc = "BufDelete";
      }
      {
        action = mkRaw ''
          function()
            require("snacks").bufdelete.delete({force=true})
          end
        '';
        key = "<localleader>Q";
        options.desc = "BufDelete force";
      }
      {
        action = mkRaw ''
          function()
            require("snacks").bufdelete.all()
          end
        '';
        key = "<localleader>bA";
        options.desc = "BufDelete all";
      }
      {
        action = mkRaw ''
          function()
            require("snacks").bufdelete.other()
          end
        '';
        key = "<localleader>bO";
        options.desc = "BufDelete other";
      }
    ]);
    keymaps =
      [
        {
          action = mkRaw ''
            function()
              require("snacks").picker.buffers({current = false, sort_lastused = true})
            end
          '';
          key = "<leader>b";
          options.desc = "Buffers";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.git_files()
            end
          '';
          key = "<leader>ff";
          options.desc = "Find git files";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.files({hidden = true, ignored = true})
            end
          '';
          key = "<leader>fF";
          options.desc = "Find files";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.files({
                hidden = true,
                cwd = vim.fn.expand("%:p:h")
              })
            end
          '';
          key = "<leader>fl";
          options.desc = "Find files relative to current file";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.files({ cwd = os.getenv("DOTFILES") })
            end
          '';
          key = "<leader>fv";
          options.desc = "Find files in DOTFILES";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.grep()
            end
          '';
          key = "<leader>fs";
          options.desc = "Grep";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.projects()
            end
          '';
          key = "<leader>fp";
          options.desc = "Projects";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.recent()
            end
          '';
          key = "<leader>fr";
          options.desc = "Recent";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.explorer({auto_close = true, follow_file = false})
            end
          '';
          key = "<leader>fb";
          options.desc = "File explorer";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.explorer({auto_close = true, follow_file = true})
            end
          '';
          key = "<leader>fB";
          options.desc = "File explorer relative to current file";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.git_branches()
            end
          '';
          key = "<leader>gb";
          options.desc = "Git branches";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.command_history()
            end
          '';
          key = "<leader>f;";
          options.desc = "Command history";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.search_history()
            end
          '';
          key = "<leader>f/";
          options.desc = "Search history";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.qflist()
            end
          '';
          key = "<leader>fq";
          options.desc = "Quickfix list";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").picker.undo()
            end
          '';
          key = "<leader>fU";
          options.desc = "Undo";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").toggle()
            end
          '';
          key = "<localleader>g";
          options.desc = "Snacks toggle";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").scratch()
            end
          '';
          key = "<localleader>.";
          options.desc = "Toggle scratch buffer";
        }
        {
          action = mkRaw ''
            function()
              require("snacks").scratch.select()
            end
          '';
          key = "<localleader>S";
          options.desc = "Select scratch buffer";
        }
      ]
      ++ (lib.optionals config.plugins.todo-comments.enable [
        {
          action = mkRaw ''
            function()
              require("snacks").picker.todo_comments()
            end
          '';
          key = "<leader>fT";
          options.desc = "Todo comments";
        }
      ])
      ++ (lib.optionals config.plugins.trouble.enable [
        {
          action = mkRaw ''
            function()
              require("snacks").picker.todo_comments()
            end
          '';
          key = "<leader>ft";
          options.desc = "Todo comments";
        }
      ])
      ++ keymapsTerm ++ keymapsBufDel;
  in {
    inherit keymaps;
    plugins.snacks = let
      cfg = config.plugins.snacks;
    in {
      luaConfig.post = lib.mkIf (cfg.enable
        && cfg.settings.debug.enabled) ''
        _G.dd = function(...)
          require("snacks").debug.inspect(...)
        end
        _G.bt = function(...)
          require("snacks").debug.backtrace(...)
        end
      '';
      settings = {
        bufdelete.enabled = true;
        debug.enabled = true;
        indent.enabled = true;
        picker.enabled = true;
        profiles.enabled = true;
        scope.enabled = true;
        scratch.enabled = true;
        scroll.enabled = true;
        statuscolumn.enabled = true;
        terminal = {
          enabled = true;
          shell = "nu";
        };
        toggle.enabled = true;
        words.enabled = true;
      };
    };
  };
}
