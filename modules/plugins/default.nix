{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.my.mkKey) mkKeyMap keymapUnlazy keymap2Lazy wKeyObj;
  maximize-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "maximize-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "declancm";
      repo = "/maximize.nvim";
      rev = "d688b66344b03ee6e5a32a0a40af85d174490af8";
      hash = "sha256-rwnvX+Sul+bwESZtpqbvaDJuk49SV9tLUnvgiAH4VMs=";
    };
  };
  keymapsCzr = builtins.map mkKeyMap (lib.optionals config.plugins.colorizer.enable [
    {
      action.__raw = ''
        function()
          vim.g.colorizing_enabled = not vim.g.colorizing_enabled
          vim.cmd('ColorizerToggle')
          vim.notify(string.format("Colorizing %s", bool2str(vim.g.colorizing_enabled), "info"))
        end
      '';
      key = "<leader>uC";
      mode = "n";
      options.desc = "Colorizer toggle";
      options.silent = true;
    }
  ]);
  keymapsOil = builtins.map mkKeyMap (lib.optionals config.plugins.oil.enable [
    {
      action = "<cmd>Oil<CR>";
      key = "<leader>o";
      mode = "n";
      options.desc = "Open Oil file browser";
    }
  ]);
  keymapsMax = builtins.map mkKeyMap [
    {
      action.__raw = ''
        function()
          require("maximize").toggle()
        end
      '';
      key = "<leader>z";
      mode = "n";
      options.desc = "Maximize windows";
    }
  ];
  keymapsDial = [
    {
      action.__raw = ''
        function()
          require("dial.map").inc_normal()
        end
      '';
      key = "<M-a>";
      mode = "n";
      options.desc = "Increment number";
      options.expr = true;
    }
    {
      action.__raw = ''
        function()
          require("dial.map").dec_normal()
        end
      '';
      key = "<M-x>";
      mode = "n";
      options.desc = "Decrement number";
      options.expr = true;
    }
  ];
  keymapsAS = builtins.map mkKeyMap (lib.optionals config.plugins.auto-session.enable [
    {
      action = "<cmd>SessionRestore<CR>";
      key = "<leader>q.";
      mode = "n";
      options.desc = "Restore last session";
    }
    {
      action = "<cmd>Autosession search<CR>";
      key = "<leader>qs";
      mode = "n";
      options.desc = "List session";
    }
    {
      action = "<cmd>Autosession delete<CR>";
      key = "<leader>qd";
      mode = "n";
      options.desc = "Delete session";
    }
    {
      action = "<cmd>SessionSave<CR>";
      key = "<leader>qs";
      mode = "n";
      options.desc = "Save session";
    }
    {
      action = "<cmd>SessionPurgeOrphaned<CR>";
      key = "<leader>qD";
      mode = "n";
      options.desc = "Purge orphaned sessions";
    }
  ]);
  keymapsCom = builtins.map mkKeyMap (lib.optionals config.plugins.comment.enable [
    {
      action = "yy<Plug>(comment_toggle_linewise_current)p";
      key = "<localleader>cc";
      mode = "n";
      options.desc = "Duplicate and comment line";
    }
    {
      action = "ygv<Plug>(comment_toggle_linewise_visual)`>p";
      key = "<localleader>cc";
      mode = "x";
      options.desc = "Duplicate and comment visual block";
    }
  ]);
  keymapsPj = builtins.map mkKeyMap (lib.optionals (config.plugins.telescope.enable && config.plugins.project-nvim.enable) [
    {
      action = "<cmd>Telescope projects<CR>";
      key = "<leader>fp";
      options.desc = "Find projects";
    }
  ]);
in {
  extraPlugins = with pkgs.vimPlugins; [
    dial-nvim
    maximize-nvim
    mini-icons
    playground
    vim-gnupg
    vim-indent-object
    Navigator-nvim
  ];
  extraConfigLua = ''
    require("Navigator").setup()
  '';
  globals = {
    GPGPreferArmor = 1;
    GPGPreferSign = 1;
  };
  imports = with builtins;
    map (fn: ./${fn})
    (filter
      (fn: (
        fn != "default.nix"
      ))
      (attrNames (readDir ./.)));
  keymaps =
    keymapsPj
    ++ [
      {
        action.__raw = ''
          function()
            require("Navigator").left()
          end
        '';
        key = "<M-h>";
        mode = "n";
        options.desc = "Move to left window";
      }
      {
        action.__raw = ''
          function()
            require("Navigator").down()
          end
        '';
        key = "<M-j>";
        mode = "n";
        options.desc = "Move to down window";
      }
      {
        action.__raw = ''
          function()
            require("Navigator").up()
          end
        '';
        key = "<M-k>";
        mode = "n";
        options.desc = "Move to up window";
      }
      {
        action.__raw = ''
          function()
            require("Navigator").right()
          end
        '';
        key = "<M-l>";
        mode = "n";
        options.desc = "Move to right window";
      }
    ]
    ++ (keymapUnlazy (
      keymapsAS
      ++ keymapsCzr
      ++ keymapsDial
      ++ keymapsMax
      ++ keymapsOil
      ++ keymapsCom
      ++ [
        {
          action = "<cmd>UndotreeToggle<CR>";
          key = "<leader>U";
          mode = "n";
          options.desc = "Toggle Undotree";
        }
      ]
    ));
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "maximize-nvim";
        after = ''
          function()
            require("maximize").setup({})
          end
        '';
        keys = keymap2Lazy keymapsMax;
      }
      {
        __unkeyed-1 = "playground";
        cmd = "TSPlaygroundToggle";
      }
      {
        __unkeyed-1 = "vim-gnupg";
        ft = [
          "gpg"
          "asc"
          "pgp"
        ];
      }
      {
        __unkeyed-1 = "dial-nvim";
        event = "BufReadPre";
        keys = keymap2Lazy keymapsDial;
        after = ''
          function()
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
          end
        '';
      }
    ];
    auto-session = {
      enable = true;
      lazyLoad.settings.keys = keymap2Lazy keymapsAS;
      settings = {
        auto_save = true;
        auto_restore = false;
      };
    };
    colorizer = {
      enable = true;
      lazyLoad.settings.keys = keymap2Lazy keymapsCzr;
      settings.user_default_options = {
        mode = "virtualtext";
        names = false;
      };
    };
    direnv.enable = true;
    harpoon = {
      enable = true;
      enableTelescope = config.plugins.telescope.enable;
      keymaps = {
        addFile = "<leader>hm";
        toggleQuickMenu = "<leader>hu";
      };
    };
    helm.enable = true;
    indent-blankline = {
      enable = true;
      lazyLoad.settings.event = "BufReadPre";
      settings.indent = {
        char = [
          "|"
          "¦"
          "┆"
          "┊"
        ];
        priority = 50;
      };
    };
    nvim-bqf.enable = true;
    oil = {
      enable = true;
      lazyLoad.settings = {
        cmd = "Oil";
        keys = keymap2Lazy keymapsOil;
      };
    };
    project-nvim = {
      enable = true;
      enableTelescope = config.plugins.telescope.enable;
      lazyLoad.settings = {
        # keys = keymap2Lazy keymapsPj;
        event = "DeferredUIEnter";
        before.__raw = ''
          require("lz.n").trigger_load("telescope")
        '';
      };
      settings = {
        detection_methods = ["pattern" "lsp"];
        scope_chdir = "win";
        show_hidden = true;
      };
    };
    twilight = {
      enable = true;
      lazyLoad.settings.cmd = "Twilight";
    };
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
    toggleterm = let
      map = ''[[<C-\>]]'';
    in {
      enable = true;
      lazyLoad.settings = {
        cmd = "ToggleTerm";
        keys = [
          {
            __unkeyed-1 = map;
            __unkeyed-2 = "<cmd>ToggleTerm<CR>";
            desc = "ToggleTerm";
          }
        ];
      };
      settings = {
        open_mapping = map;
        hide_numbers = true;
      };
    };
  };
  my.wKeyList = lib.optionals config.plugins.telescope.enable [
    (wKeyObj ["<leader>q" "" "Session"])
  ];
}
