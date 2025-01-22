{ config, ... }:
{
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
  keymaps = [
    {
      action.__raw = ''require("gitsigns").next_hunk'';
      key = "]h";
      mode = "n";
      options.desc = "Next git hunk";
    }
    {
      action.__raw = ''require("gitsigns").prev_hunk'';
      key = "[h";
      mode = "n";
      options.desc = "Previous git hunk";
    }
    {
      action.__raw = ''require("gitsigns").preview_hunk'';
      key = "<leader>gv";
      mode = "n";
      options.desc = "Preview git hunk";
    }
    {
      action.__raw = ''require("gitsigns").stage_buffer'';
      key = "<leader>gT";
      mode = "n";
      options.desc = "Stage buffer";
    }
    {
      action.__raw = ''require("gitsigns").reset_buffer'';
      key = "<leader>gR";
      mode = "n";
      options.desc = "Reset buffer";
    }
    {
      action.__raw = ''require("gitsigns").stage_hunk'';
      key = "<leader>gt";
      mode = "n";
      options.desc = "Stage git hunk";
    }
    {
      action.__raw = ''require("gitsigns").undo_stage_hunk'';
      key = "<leader>gu";
      mode = "n";
      options.desc = "Undo stage git hunk";
    }
    {
      action.__raw = ''require("gitsigns").diffthis'';
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
      action.__raw = ''require("gitsigns").toggle_current_line_blame'';
      key = "<leader>gB";
      mode = "n";
      options.desc = "Toggle current line blame";
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
  ];
  plugins = {
    diffview.enable = true;
    fugitive.enable = true;
    gitsigns.enable = true;
    gitlinker.enable = true;
    git-worktree = {
      enable = true;
      enableTelescope = config.plugins.telescope.enable;
    };
  };
}
