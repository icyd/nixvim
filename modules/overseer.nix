{
  flake.modules.nixvim.overseer = {config, ...}: let
    cfg = config.plugins.overseer;
    inherit (config.utils.mkKey) mkKeyMapIf keymapUnlazy keymap2Lazy wKeyObjMapIf;
    keymaps = mkKeyMapIf cfg.enable [
      {
        action = "<cmd>OverseerRun<CR>";
        key = "<leader>RR";
        options.desc = "Run task";
      }
      {
        action = "<cmd>OverseerOpen<CR>";
        key = "<leader>Ro";
        options.desc = "Open output";
      }
      {
        action = "<cmd>OverseerToggle<CR>";
        key = "<leader>Rt";
        options.desc = "Toggle output";
      }
      {
        action = "<cmd>OverseerShell<CR>";
        key = "<leader>Rs";
        options.desc = "Run shell command";
      }
      {
        action = "<cmd>OverseerTaskAction<CR>";
        key = "<leader>RA";
        options.desc = "Task action";
      }
      {
        action.__raw = ''
          function()
            local overseer = require("overseer")
            local task_list = require("overseer.task_list")
            local tasks = overseer.list_tasks({ status = {
              overseer.STATUS.SUCCESS,
              overseer.STATUS.FAILURE,
              overseer.STATUS.CANCELED,
            }, sort = task_list.sort_finished_recently})
            if vim.tbl_isempty(tasks) then
              vim.notify("No tasks found", vim.log.levels.WARN)
            else
              overseer.run_action(tasks[1], "restart")
            end
          end
        '';
        key = "<leader>Rl";
        options.desc = "Restart last action";
      }
    ];
  in {
    keymaps = keymapUnlazy keymaps;
    plugins = {
      overseer = {
        enable = true;
        lazyLoad.settings = {
          cmd = [
            "OverseerOpen"
            "OverseerToggle"
            "OverseerRun"
            "OverseerShell"
            "OverseerTaskAction"
          ];
          keys = keymap2Lazy keymaps;
        };
        luaConfig.post = ''
          vim.cmd.cnoreabbrev("OS OverseerShell")
          local overseer = require("overseer")
          overseer.register_template({
            name = "Nix build",
            desc = "Run nix build in current flake or directory",
            tags = { overseer.TAG.BUILD },
            params = {
              target = {
                desc = "Build target",
                type = "string",
                default = ".#",
              },
              additional_args = {
                desc = "Extra flags",
                type = "string",
                default = "--print-build-logs",
              },
            },
            builder = function(params)
              local cmd_args = { "build" }

              if params.target ~= "" then
                table.insert(cmd_args, params.target)
              end

              if params.additional_args ~= "" then
                for arg in string.gmatch(params.additional_args, "%S+") do
                  table.insert(cmd_args, arg)
                end
              end

              return {
                cmd = { "nix" },
                args = cmd_args,
                components = {
                  {
                    "on_output_parse",
                    parser = {
                      diagnostics = {
                        {
                          pattern = "error:([^\n]+)at%s+(.+):(%d+):(%d+)",
                          groups = { "message", "filename", "lnum", "col" },
                        },
                      },
                    },
                  },
                  "default",
                },
              }
            end,
            condition = {
              callback = function(search)
                return vim.fn.filereadable(vim.fn.getcwd() .. "/flake.nix") == 1
                  or vim.fn.filereadable(vim.fn.getcwd() .. "/default.nix")
              end,
            },
          })
          -- overseer.register_template({
          --   name = "Run via Nushell",
          --   desc = "Execute a command or alias inside Nushell login context",
          --   params = {
          --     command = {
          --       type = "string",
          --       desc = "Command to execute",
          --     },
          --   },
          --   builder = function(params)
          --     local cmd_args = { "--login", "-c" }

          --     if params.command ~= "" then
          --       for arg in string.gmatch(params.command, "%S+") do
          --         table.insert(cmd_args, arg)
          --       end
          --     end

          --     return {
          --       cmd = { "nu" },
          --       args = cmd_args,
          --       components = {
          --         "default",
          --       },
          --     }
          --   end,
          -- })
        '';
      };
    };
    userCommands.Make = {
      desc = "Run makeprg as Overseer task";
      bang = true;
      nargs = "*";
      command.__raw = ''
        function(params)
          local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
          if num_subs == 0 then
            cmd = cmd .. " " .. params.args
          end
          local task = require("overseer").new_task({
            cmd = vim.fn.expandcmd(cmd),
            components = {
              {
                "on_output_quickfix",
                open = not params.bang,
                open_height = 8,
                errorformat = vim.o.errorformat,
              },
              "default",
            },
          })
          task:start()
        end
      '';
    };
    utils.wKeyList = wKeyObjMapIf cfg.enable [
      ["<leader>R" "" "Overseer"]
    ];
  };
}
