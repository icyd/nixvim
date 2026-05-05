{
  flake.modules.nixvim.overseer = {config, ...}: let
    cfg = config.plugins.overseer;
    inherit (config.utils.mkKey) mkKeyMapIf keymapUnlazy keymap2Lazy wKeyObjMapIf;
    keymaps = mkKeyMapIf cfg.enable [
      {
        action = "<cmd>OveeseerRun<CR>";
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
