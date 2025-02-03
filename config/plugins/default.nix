{
  lib,
  config,
  pkgs,
  ...
}:
let
  maximize-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "maximize-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "declancm";
      repo = "/maximize.nvim";
      rev = "d688b66344b03ee6e5a32a0a40af85d174490af8";
      hash = "sha256-rwnvX+Sul+bwESZtpqbvaDJuk49SV9tLUnvgiAH4VMs=";
    };
  };
in
{
  extraConfigLua = ''
    local augend = require('dial.augend')
    require('dial.config').augends:register_group({
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.alias['%Y/%m/%d'],
        augend.constant.alias.bool,
        augend.semver.alias.semver,
      },
    })

    require("maximize").setup()
    require("unimpaired").setup()
  '';
  extraPlugins = with pkgs.vimPlugins; [
    dial-nvim
    maximize-nvim
    mini-icons
    playground
    unimpaired-nvim
    vim-gnupg
  ];
  extraFiles = {
    "lua/snippets/utils.lua".source = ../../lua/snippets/utils.lua;
  };
  globals = {
    # rooter_cd_cmd = "lcd";
    # rooter_resolve_links = 1;
    GPGPreferArmor = 1;
    GPGPreferSign = 1;
  };
  imports = [
    ./core.nix
    ./completion.nix
    ./debugging.nix
    ./format.nix
    ./git.nix
    ./lint.nix
    ./lsp.nix
    ./neorg.nix
    ./project.nix
    ./telescope.nix
    ./tests.nix
    ./treesitter.nix
    ./yanky.nix
  ];
  keymaps = [
    {
      action = "<cmd>AerialToggle!<CR>";
      key = "<leader>xa";
      mode = "n";
      options.desc = "Aerial toggle";
    }
    {
      action = "<cmd>Navbuddy<CR>";
      key = "<leader>xn";
      mode = "n";
      options.desc = "Navbuddy toggle";
    }
    {
      action = "<cmd>Oil<CR>";
      key = "<leader>o";
      mode = "n";
      options.desc = "Open Oil file browser";
    }
    {
      action = "<cmd>UndotreeToggle<CR>";
      key = "<leader>U";
      mode = "n";
      options.desc = "Toggle Undotree";
    }
    {
      action.__raw = ''require("maximize").toggle'';
      key = "<leader>z";
      mode = "n";
      options.desc = "Maximize windows";
    }
    {
      action.__raw = ''require("flash").jump'';
      key = "s";
      mode = [
        "n"
        "x"
        "o"
      ];
      options.desc = "Flash";
    }
    {
      action.__raw = ''require("flash").treesitter'';
      key = "S";
      mode = [
        "n"
        "x"
        "o"
      ];
      options.desc = "Flash Tressiter";
    }
    {
      action.__raw = ''require("flash").remote'';
      key = "r";
      mode = "o";
      options.desc = "Remote Flash";
    }
    {
      action.__raw = ''require("flash").treesitter_search'';
      key = "R";
      mode = [
        "x"
        "o"
      ];
      options.desc = "Flash Tressiter Search";
    }
    {
      action.__raw = ''require("flash").toggle'';
      key = "<C-s>";
      mode = "c";
      options.desc = "Toggle Flash Search";
    }
    {
      action.__raw = ''
        function()
          require("flash").jump({
            search = { mode = "search", max_length = 0 },
            label = { after = { 0, 0 } },
            pattern = "^"
          })
        end
      '';
      key = "<localleader>l";
      mode = "n";
      options.desc = "Hop to line";
    }
    {
      action.__raw = ''require("todo-comments").jump_next'';
      key = "]t";
      mode = "n";
      options.desc = "Go to next todo comment";
    }
    {
      action.__raw = ''require("todo-comments").jump_prev'';
      key = "[t";
      mode = "n";
      options.desc = "Go to previous todo comment";
    }
    {
      action.__raw = ''
        function()
          if vim.v.count > 0 then
              return require("harpoon.ui").nav_file(vim.v.count)
          end

          require("harpoon.ui").nav_next()
        end
      '';
      key = "<leader>hg";
      mode = "n";
      options.desc = "Harpoon goto next file";
    }
    {
      action.__raw = ''
        function()
          if vim.v.count > 0 then
              return require("harpoon.ui").nav_file(vim.v.count)
          end

          require("harpoon.ui").nav_prev()
        end
      '';
      key = "<leader>hG";
      mode = "n";
      options.desc = "Harpoon goto prev file";
    }
    {
      action.__raw = ''
        function()
          require("harpoon.term").gotoTerminal(vim.v.count1)
        end
      '';
      key = "<leader>ht";
      mode = "n";
      options.desc = "Harpoon goto terminal";
    }
    {
      action.__raw = ''
        function()
          require("telescope").extensions.harpoon.marks()
        end
      '';
      key = "<leader>hU";
      mode = "n";
      options.desc = "Harpoon telescope menu";
    }
    {
      action.__raw = ''
        require("dial.map").inc_normal
      '';
      key = "<M-a>";
      mode = "n";
      options.desc = "Increment number";
      options.expr = true;
    }
    {
      action.__raw = ''
        require("dial.map").dec_normal
      '';
      key = "<M-x>";
      mode = "n";
      options.desc = "Decrement number";
      options.expr = true;
    }
    {
      action.__raw = ''require("trouble").toggle'';
      key = "<leader>xx";
      mode = "n";
      options.desc = "Trouble toggle";
    }
    {
      action.__raw = ''function()
        require("trouble").toggle("workspace_diagnostics")
      end'';
      key = "<leader>xD";
      mode = "n";
      options.desc = "Trouble workspace diagnostics";
    }
    {
      action.__raw = ''function()
        require("trouble").toggle("document_diagnostics")
      end'';
      key = "<leader>xd";
      mode = "n";
      options.desc = "Trouble diagnostics";
    }
    {
      action.__raw = ''function()
        require("trouble").toggle("loclist")
      end'';
      key = "<leader>xl";
      mode = "n";
      options.desc = "Trouble loclist";
    }
    {
      action.__raw = ''function()
        require("trouble").toggle("quickfix")
      end'';
      key = "<leader>xq";
      mode = "n";
      options.desc = "Trouble quickfix";
    }
    {
      action.__raw = ''function()
        require("trouble").toggle("lsp_references")
      end'';
      key = "<leader>xR";
      mode = "n";
      options.desc = "Trouble Lsp references";
    }
    {
      action.__raw = ''function()
        require("trouble").first({ skip_groups = true, jump = true})
      end'';
      key = "[X";
      mode = "n";
      options.desc = "Trouble go to first";
    }
    {
      action.__raw = ''function()
        require("trouble").previous({ skip_groups = true, jump = true})
      end'';
      key = "[x";
      mode = "n";
      options.desc = "Trouble go to previous";
    }
    {
      action.__raw = ''function()
        require("trouble").next({ skip_groups = true, jump = true})
      end'';
      key = "]x";
      mode = "n";
      options.desc = "Trouble go to next";
    }
    {
      action.__raw = ''function()
        require("trouble").last({ skip_groups = true, jump = true})
      end'';
      key = "]X";
      mode = "n";
      options.desc = "Trouble go to last";
    }
  ];
  plugins = {
    colorizer.enable = true;
    direnv.enable = true;
    flash = {
      enable = true;
      settings = {
        jump.autojump = true;
        # modes.char.jump_labels = true;
        modes.char.multi_line = false;
      };
    };
    firenvim = {
      enable = true;
    };
    harpoon = {
      enable = true;
      enableTelescope = config.plugins.telescope.enable;
      keymaps = {
        addFile = "<leader>hm";
        toggleQuickMenu = "<leader>hu";
      };
    };
    lualine = {
      enable = true;
      luaConfig.pre = ''
        local function maximize_status()
            return vim.t.maximized and "   " or ""
        end
      '';
      settings = {
        sections = {
          lualine_x.__raw = ''
            {
                            "encoding",
                            "fileformat",
                            "filetype",
                            maximize_status,
                      }'';
        };
        winbar = {
          lualine_b = [
            {
              __unkeyed-0 = "diagnostics";
            }
          ];
          lualine_c = lib.mkIf config.plugins.navic.enable [
            {
              __unkeyed-0 = "navic";
            }
          ];
          lualine_x = [
            {
              __unkeyed-0 = "filename";
              file_status = true;
              newfile_status = true;
              path = 3;
            }
          ];
        };
      };
    };
    lz-n.enable = true;
    navic = {
      enable = true;
      settings.lsp.auto_attach = true;
    };
    navbuddy = {
      enable = true;
      lsp.autoAttach = true;
    };
    nvim-bqf.enable = true;
    oil.enable = true;
    otter = {
      enable = true;
      settings.buffers.set_filetype = true;
    };
    sqlite-lua.enable = true;
    todo-comments.enable = true;
    toggleterm = {
      enable = true;
      settings = {
        open_mapping = ''[[<C-\>]]'';
        hide_numbers = true;
      };
    };
    trouble.enable = true;
    twilight.enable = true;
    undotree = {
      enable = true;
      settings.WindowLayout = 3;
    };
    vim-bbye = {
      enable = true;
      keymaps = {
        bdelete = "<localleader>q";
        bwipeout = "<localleader>Q";
      };
      keymapsSilent = true;
    };
    web-devicons.enable = true;
    which-key.enable = true;
  };
   performance = {
    byteCompileLua = {
      enable = true;
      nvimRuntime = true;
      configs = true;
      plugins = true;
    };
  };
}
