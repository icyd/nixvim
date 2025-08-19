{
  flake.modules.nixvim.git = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap wKeyObj;
    inherit (lib.nixvim.utils) mkRaw;
    cfgGW = config.plugins.git-worktree;
    keymapsGW = lib.optionals (cfgGW.enable && cfgGW.enableTelescope) [
      {
        action = "<cmd>Telescope git_worktree<CR>";
        key = "<leader>gWg";
        options.desc = "Git worktree";
      }
      {
        action = "<cmd>Telescope git_worktree create_git_worktree<CR>";
        key = "<leader>gWc";
        options.desc = "Create git worktree";
      }
      {
        action = "<cmd>Telescope git_worktree git_worktrees<CR>";
        key = "<leader>gWs";
        options.desc = "Switch / Delete git worktrees";
      }
    ];
    keymapsGC = lib.optionals config.plugins.git-conflict.enable [
      {
        action = "<cmd>GitConflictListQf<CR>";
        key = "<leader>gcl";
        options.desc = "Git conflict to quicklist";
      }
      {
        action = "<cmd>GitConflictRefresh<CR>";
        key = "<leader>gcr";
        options.desc = "Git conflict refresh";
      }
    ];
    keymapsGI = lib.optionals config.plugins.gitignore.enable [
      {
        action = mkRaw ''
          function()
            require("gitignore").generate()
          end
        '';
        key = "<leader>gi";
        options.desc = "Generate .gitignore file";
      }
    ];
    keymapsGL = lib.optionals config.plugins.gitlinker.enable (builtins.map (mode: {
      inherit mode;
      action = mkRaw ''
        function()
          require("gitlinker").get_buf_range_url("${mode}")
        end
      '';
      key = "<leader>gy";
      options.desc = "Generate git url";
    }) ["n" "v"]);
    keymapsLG = lib.optionals config.plugins.lazygit.enable [
      {
        action = "<cmd>LazyGit<CR>";
        key = "<leader>gl";
        options.desc = "Lazygit";
      }
    ];
    keymaps = builtins.map mkKeyMap ([
        {
          action = mkRaw ''
            function()
              require("gitsigns").next_hunk()
            end
          '';
          key = "]h";
          options.desc = "Next git hunk";
        }
        {
          action = mkRaw ''
            function()
              require("gitsigns").prev_hunk()
            end
          '';
          key = "[h";
          options.desc = "Previous git hunk";
        }
        {
          action = mkRaw ''
            function()
              require("gitsigns").preview_hunk()
            end
          '';
          key = "<leader>gv";
          options.desc = "Preview git hunk";
        }
        {
          action = mkRaw ''
            function()
              require("gitsigns").preview_hunk_inline()
            end
          '';
          key = "<leader>gV";
          options.desc = "Preview git hunk inline";
        }
        {
          action = mkRaw ''
            function()
              require("gitsigns").stage_buffer()
            end
          '';
          key = "<leader>gT";
          options.desc = "Stage buffer";
        }
        {
          action = mkRaw ''
            function()
              require("gitsigns").reset_buffer()
            end
          '';
          key = "<leader>gR";
          options.desc = "Reset buffer";
        }
        {
          action = mkRaw ''
            function()
              require("gitsigns").stage_hunk()
            end
          '';
          key = "<leader>gt";
          options.desc = "Stage git hunk";
        }
        {
          action = mkRaw ''
            function()
              require("gitsigns").undo_stage_hunk()
            end
          '';
          key = "<leader>gu";
          options.desc = "Undo stage git hunk";
        }
        {
          action = mkRaw ''
            function()
              require("gitsigns").diffthis()
            end
          '';
          key = "<leader>gd";
          options.desc = "Diff this git hunk";
        }
        {
          action = mkRaw ''
            function()
              require("gitsigns").diffthis("~")
            end
          '';
          key = "<leader>gD";
          options.desc = "Diff this git hunk against commit";
        }
        {
          action = mkRaw ''
            function()
              require("gitsigns").blame_line({full=true})
            end
          '';
          key = "<leader>gb";
          options.desc = "Git blame line";
        }
        {
          action = mkRaw ''
            function()
              require("gitsigns").blame()
            end
          '';
          key = "<leader>gB";
          options.desc = "Git blame buffer";
        }
        {
          action = "<cmd>Git<CR>";
          key = "<leader>gs";
          options.desc = "Git status";
        }
        {
          action = "<cmd>Gvdiffsplit!<CR>";
          key = "<leader>gp";
          options.desc = "Git diff vertical split";
        }
        {
          action = "<cmd>Git -c push.default=current push<CR>";
          key = "<leader>gP";
          options.desc = "Git push to upstream";
        }
        {
          action = "<cmd>Git pull<CR>";
          key = "<leader>gp";
          options.desc = "Git pull";
        }
        {
          action = "<cmd>diffget //2<CR>";
          key = "<leader>gh";
          options.desc = "Git diff get left";
        }
        {
          action = "<cmd>diffget //3<CR>";
          key = "<leader>gl";
          options.desc = "Git diff get right";
        }
      ]
      ++ keymapsGI
      ++ keymapsGL
      ++ keymapsLG
      ++ keymapsGC
      ++ keymapsGW);
  in {
    inherit keymaps;
    autoGroups = {
      fugitive.clear = true;
    };
    autoCmd = [
      {
        command = "setlocal bufhidden=delete";
        desc = "Disable buffhidden on fugitive buffers";
        event = "BufReadPost";
        group = "fugitive";
        pattern = "fugitive://*";
      }
      {
        command = "if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' nnoremap <buffer> .. :edit %:h<CR> | endif";
        desc = "Edit git buffer";
        event = "User";
        group = "fugitive";
        pattern = "fugitive";
      }
    ];
    plugins = {
      fugitive.enable = true;
      lazygit.enable = true;
      gitignore.enable = true;
      gitsigns = {
        enable = true;
        lazyLoad.settings.event = "BufReadPre";
      };
      gitlinker.enable = true;
      git-conflict = {
        enable = true;
        # lazyLoad.settings.keys = keymap2Lazy keymapsGC;
      };
      git-worktree = {
        enable = true;
        enableTelescope = config.plugins.telescope.enable;
        # lazyLoad.settings.keys = keymap2Lazy keymapsGW;
      };
    };
    utils.wKeyList =
      [
        (wKeyObj ["<leader>g" "" "Git"])
      ]
      ++ (lib.optionals (cfgGW.enable && cfgGW.enableTelescope) [
        (wKeyObj ["<leader>gW" "󰙅 " "Git worktree"])
      ])
      ++ (lib.optionals config.plugins.git-conflict.enable [
        (wKeyObj ["<leader>gc" "" "Git conflict"])
      ]);
  };
}
