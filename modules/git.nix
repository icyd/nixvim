{
  nixpkgs.allowedUnfreePackages = [
    "git-conflict.nvim"
  ];
  flake.modules.nixvim.git = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap mkKeyMapIf wKeyObjMap keymap2Lazy keymapUnlazy;
    keysGitConflict = mkKeyMapIf config.plugins.git-conflict.enable [
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
    keysGitIgnore = mkKeyMapIf config.plugins.gitignore.enable [
      {
        action.__raw = ''
          function()
            require("gitignore").generate()
          end
        '';
        key = "<leader>gi";
        options.desc = "Generate .gitignore file";
      }
    ];
    keysGitLinker = mkKeyMapIf config.plugins.gitlinker.enable (map (mode: {
      inherit mode;
      action.__raw = ''
        function()
          require("gitlinker").get_buf_range_url("${mode}")
        end
      '';
      key = "<leader>gy";
      options.desc = "Generate git url";
    }) ["n" "v"]);
    keysLazyGit = let
      snacks = config.plugins.snacks.enable && config.plugins.snacks.settings.lazygit.enabled;
    in
      lib.optionals (config.plugins.lazygit.enable || snacks) (
        if snacks
        then [
          {
            action.__raw = ''
              function()
                require("snacks").lazygit.open()
              end
            '';
            key = "<leader>gl";
            options.desc = "Lazygit";
          }
          {
            action.__raw = ''
              function()
                require("snacks").lazygit.log()
              end
            '';
            key = "<leader>go";
            options.desc = "Lazygit log";
          }
          {
            action.__raw = ''
              function()
                require("snacks").lazygit.log_file()
              end
            '';
            key = "<leader>gO";
            options.desc = "Lazygit log of current file";
          }
        ]
        else [
          {
            action = "<cmd>LazyGit<CR>";
            key = "<leader>gl";
            options.desc = "Lazygit";
          }
        ]
      );
    keymaps =
      mkKeyMap [
        {
          action.__raw = ''
            function()
              require("gitsigns").next_hunk()
            end
          '';
          key = "]h";
          options.desc = "Next git hunk";
        }
        {
          action.__raw = ''
            function()
              require("gitsigns").prev_hunk()
            end
          '';
          key = "[h";
          options.desc = "Previous git hunk";
        }
        {
          action.__raw = ''
            function()
              require("gitsigns").preview_hunk()
            end
          '';
          key = "<leader>gv";
          options.desc = "Preview git hunk";
        }
        {
          action.__raw = ''
            function()
              require("gitsigns").preview_hunk_inline()
            end
          '';
          key = "<leader>gV";
          options.desc = "Preview git hunk inline";
        }
        {
          action.__raw = ''
            function()
              require("gitsigns").stage_buffer()
            end
          '';
          key = "<leader>gT";
          options.desc = "Stage buffer";
        }
        {
          action.__raw = ''
            function()
              require("gitsigns").reset_buffer()
            end
          '';
          key = "<leader>gR";
          options.desc = "Reset buffer";
        }
        {
          action.__raw = ''
            function()
              require("gitsigns").stage_hunk()
            end
          '';
          key = "<leader>gt";
          options.desc = "Stage git hunk";
        }
        {
          action.__raw = ''
            function()
              require("gitsigns").undo_stage_hunk()
            end
          '';
          key = "<leader>gu";
          options.desc = "Undo stage git hunk";
        }
        {
          action.__raw = ''
            function()
              require("gitsigns").diffthis()
            end
          '';
          key = "<leader>gd";
          options.desc = "Diff this git hunk";
        }
        {
          action.__raw = ''
            function()
              require("gitsigns").diffthis("~")
            end
          '';
          key = "<leader>gD";
          options.desc = "Diff this git hunk against commit";
        }
        {
          action.__raw = ''
            function()
              require("gitsigns").blame_line({full=true})
            end
          '';
          key = "<leader>gb";
          options.desc = "Git blame line";
        }
        {
          action.__raw = ''
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
      ++ keysLazyGit
      ++ (keymapUnlazy (keysGitIgnore ++ keysGitLinker ++ keysGitConflict));
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
      lazygit.enable = !(config.plugins.snacks.enable && config.plugins.snacks.settings.lazygit.enabled);
      snacks.settings.lazygit.enabled = config.plugins.snacks.enable;
      gitignore = {
        enable = true;
        lazyLoad.settings.keys = keymap2Lazy keysGitIgnore;
      };
      gitsigns = {
        enable = true;
        lazyLoad.settings.event = "BufReadPre";
      };
      gitlinker = {
        enable = true;
        lazyLoad.settings.keys = keymap2Lazy keysGitLinker;
      };
      git-conflict = {
        enable = true;
        lazyLoad.settings.event = "BufReadPre";
      };
    };
    utils.wKeyList = wKeyObjMap ([
        ["<leader>g" "" "Git"]
      ]
      ++ (lib.optional config.plugins.git-conflict.enable
        ["<leader>gc" "" "Git conflict"]));
  };
}
