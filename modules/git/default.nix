{
  lib,
  config,
  ...
}: let
  inherit (config.my.mkKey) mkKeyMap wKeyObj;
  cfgGW = config.plugins.git-worktree;
  keymapsGW = lib.optionals (cfgGW.enable && cfgGW.enableTelescope) [
    {
      action = "<cmd>Telescope git_worktree<CR>";
      key = "<leader>gWg";
      mode = "n";
      options.desc = "Git worktree";
    }
    {
      action = "<cmd>Telescope git_worktree create_git_worktree<CR>";
      key = "<leader>gWc";
      mode = "n";
      options.desc = "Create git worktree";
    }
    {
      action = "<cmd>Telescope git_worktree git_worktrees<CR>";
      key = "<leader>gWs";
      mode = "n";
      options.desc = "Switch / Delete git worktrees";
    }
  ];
  keymapsGC = lib.optionals config.plugins.git-conflict.enable [
    {
      action = "<cmd>GitConflictListQf<CR>";
      key = "<leader>gcl";
      mode = "n";
      options.desc = "Git conflict to quicklist";
    }
    {
      action = "<cmd>GitConflictRefresh<CR>";
      key = "<leader>gcr";
      mode = "n";
      options.desc = "Git conflict refresh";
    }
  ];
  keymapsGI = lib.optionals config.plugins.gitignore.enable [
    {
      action.__raw = ''
        function()
          require("gitignore").generate()
        end
      '';
      key = "<leader>gi";
      mode = "n";
      options.desc = "Generate .gitignore file";
    }
  ];
  keymapsGL = lib.optionals config.plugins.gitlinker.enable (builtins.map (mode: {
    inherit mode;
    action.__raw = ''
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
      mode = "n";
      key = "<leader>gl";
      options.desc = "Lazygit";
    }
  ];
  keymaps =
    builtins.map mkKeyMap [
      {
        action.__raw = ''
          function()
            require("gitsigns").next_hunk()
          end
        '';
        key = "]h";
        mode = "n";
        options.desc = "Next git hunk";
      }
      {
        action.__raw = ''
          function()
            require("gitsigns").prev_hunk()
          end
        '';
        key = "[h";
        mode = "n";
        options.desc = "Previous git hunk";
      }
      {
        action.__raw = ''
          function()
            require("gitsigns").preview_hunk()
          end
        '';
        key = "<leader>gv";
        mode = "n";
        options.desc = "Preview git hunk";
      }
      {
        action.__raw = ''
          function()
            require("gitsigns").preview_hunk_inline()
          end
        '';
        key = "<leader>gV";
        mode = "n";
        options.desc = "Preview git hunk inline";
      }
      {
        action.__raw = ''
          function()
            require("gitsigns").stage_buffer()
          end
        '';
        key = "<leader>gT";
        mode = "n";
        options.desc = "Stage buffer";
      }
      {
        action.__raw = ''
          function()
            require("gitsigns").reset_buffer()
          end
        '';
        key = "<leader>gR";
        mode = "n";
        options.desc = "Reset buffer";
      }
      {
        action.__raw = ''
          function()
            require("gitsigns").stage_hunk()
          end
        '';
        key = "<leader>gt";
        mode = "n";
        options.desc = "Stage git hunk";
      }
      {
        action.__raw = ''
          function()
            require("gitsigns").undo_stage_hunk()
          end
        '';
        key = "<leader>gu";
        mode = "n";
        options.desc = "Undo stage git hunk";
      }
      {
        action.__raw = ''
          function()
            require("gitsigns").diffthis()
          end
        '';
        key = "<leader>gd";
        mode = "n";
        options.desc = "Diff this git hunk";
      }
      {
        action.__raw = ''
          function()
            require("gitsigns").diffthis("~")
          end
        '';
        key = "<leader>gD";
        mode = "n";
        options.desc = "Diff this git hunk against commit";
      }
      {
        action.__raw = ''
          function()
            require("gitsigns").blame_line({full=true})
          end
        '';
        key = "<leader>gb";
        mode = "n";
        options.desc = "Git blame line";
      }
      {
        action.__raw = ''
          function()
            require("gitsigns").blame()
          end
        '';
        key = "<leader>gB";
        mode = "n";
        options.desc = "Git blame buffer";
      }
      {
        action = "<cmd>Git<CR>";
        key = "<leader>gs";
        mode = "n";
        options.desc = "Git status";
      }
      {
        action = "<cmd>Gvdiffsplit!<CR>";
        key = "<leader>gp";
        mode = "n";
        options.desc = "Git diff vertical split";
      }
      {
        action = "<cmd>Git -c push.default=current push<CR>";
        key = "<leader>gP";
        mode = "n";
        options.desc = "Git push to upstream";
      }
      {
        action = "<cmd>Git pull<CR>";
        key = "<leader>gp";
        mode = "n";
        options.desc = "Git pull";
      }
      {
        action = "<cmd>diffget //2<CR>";
        key = "<leader>gh";
        mode = "n";
        options.desc = "Git diff get left";
      }
      {
        action = "<cmd>diffget //3<CR>";
        key = "<leader>gl";
        mode = "n";
        options.desc = "Git diff get right";
      }
    ]
    ++ keymapsGI
    ++ keymapsGL
    ++ keymapsLG
    ++ keymapsGC
    ++ keymapsGW;
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
  my.wKeyList =
    [
      (wKeyObj ["<leader>g" "" "Git"])
    ]
    ++ (lib.optionals (cfgGW.enable && cfgGW.enableTelescope) [
      (wKeyObj ["<leader>gW" "󰙅 " "Git worktree"])
    ])
    ++ (lib.optionals config.plugins.git-conflict.enable [
      (wKeyObj ["<leader>gc" "" "Git conflict"])
    ]);
}
