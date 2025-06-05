{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.my.mkKey) mkKeyMap keymapUnlazy keymap2Lazy wKeyObj;
  inherit (lib.nixvim.utils) mkRaw;
  age-secret = pkgs.vimUtils.buildVimPlugin {
    name = "age-secret";
    src = pkgs.fetchFromGitHub {
      owner = "histrio";
      repo = "/age-secret.nvim";
      rev = "9be5fbdac534422dc7d03eccb9d5af96f242e16f";
      hash = "sha256-3RMSaUfZyMq9aNwBrdVIP4Mh80HwIcO7I+YhFOw+NU8=";
    };
  };
  auto-pandoc = pkgs.vimUtils.buildVimPlugin {
    name = "auto-pandoc";
    src = pkgs.fetchFromGitHub {
      owner = "jghauser";
      repo = "/auto-pandoc.nvim";
      rev = "11d007dcab1dd4587bfca175e18b6017ff4ad1dc";
      hash = "sha256-VZV9xjq6S9M9eSCDE2nV8fv6kJsC4otYJ7ZGuZwpaXw=";
    };
  };
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
      action = mkRaw ''
        function()
          vim.g.colorizing_enabled = not vim.g.colorizing_enabled
          vim.cmd('ColorizerToggle')
          vim.notify(string.format("Colorizing %s", bool2str(vim.g.colorizing_enabled), "info"))
        end
      '';
      key = "<leader>uC";
      options = {
        desc = "Colorizer toggle";
        options.silent = true;
      };
    }
  ]);
  keymapsOil = builtins.map mkKeyMap (lib.optionals config.plugins.oil.enable [
    {
      action = "<cmd>Oil<CR>";
      key = "<leader>o";
      options.desc = "Open Oil file browser";
    }
  ]);
  keymapsMax = builtins.map mkKeyMap [
    {
      action = mkRaw ''
        function()
          require("maximize").toggle()
        end
      '';
      key = "<leader>z";
      options.desc = "Maximize windows";
    }
  ];
  keymapsDial = [
    {
      action = mkRaw ''
        function()
          require("dial.map").manipulate("increment", "normal")
        end
      '';
      key = "<M-a>";
      options = {
        desc = "Increment number";
      };
    }
    {
      action = mkRaw ''
        function()
          require("dial.map").manipulate("decrement", "normal")
        end
      '';
      key = "<M-x>";
      options = {
        desc = "Decrement number";
      };
    }
    {
      action = mkRaw ''
        function()
          require("dial.map").manipulate("increment", "gnormal")
        end
      '';
      key = "g<M-a>";
      options = {
        desc = "Increment number";
      };
    }
    {
      action = mkRaw ''
        function()
          require("dial.map").manipulate("decrement", "gnormal")
        end
      '';
      key = "g<M-x>";
      options = {
        desc = "Decrement number";
      };
    }
    {
      action = mkRaw ''
        function()
          require("dial.map").manipulate("increment", "visual")
        end
      '';
      key = "<M-a>";
      mode = "v";
      options = {
        desc = "Increment number";
      };
    }
    {
      action = mkRaw ''
        function()
          require("dial.map").manipulate("decrement", "visual")
        end
      '';
      key = "<M-x>";
      mode = "v";
      options = {
        desc = "Decrement number";
      };
    }
    {
      action = mkRaw ''
        function()
          require("dial.map").manipulate("increment", "gvisual")
        end
      '';
      key = "g<M-a>";
      mode = "v";
      options = {
        desc = "Increment number";
      };
    }
    {
      action = mkRaw ''
        function()
          require("dial.map").manipulate("decrement", "gvisual")
        end
      '';
      key = "g<M-x>";
      mode = "v";
      options = {
        desc = "Decrement number";
      };
    }
  ];
  keymapsAS = builtins.map mkKeyMap (lib.optionals config.plugins.auto-session.enable [
    {
      action = "<cmd>SessionRestore<CR>";
      key = "<leader>q.";
      options.desc = "Restore last session";
    }
    {
      action = "<cmd>Autosession search<CR>";
      key = "<leader>qs";
      options.desc = "List session";
    }
    {
      action = "<cmd>Autosession delete<CR>";
      key = "<leader>qd";
      options.desc = "Delete session";
    }
    {
      action = "<cmd>SessionSave<CR>";
      key = "<leader>qs";
      options.desc = "Save session";
    }
    {
      action = "<cmd>SessionPurgeOrphaned<CR>";
      key = "<leader>qD";
      options.desc = "Purge orphaned sessions";
    }
  ]);
  keymapsCom = builtins.map mkKeyMap (lib.optionals config.plugins.comment.enable [
    {
      action = "yy<Plug>(comment_toggle_linewise_current)p";
      key = "<localleader>cc";
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
  keymapsUfo = builtins.map mkKeyMap (lib.optionals config.plugins.nvim-ufo.enable [
    {
      action.__raw = ''
        function()
          require("ufo").openAllFolds()
        end
      '';
      key = "zR";
      mode = "n";
      options.desc = "Open all folds";
    }
    {
      action.__raw = ''
        function()
          require("ufo").closeAllFolds()
        end
      '';
      key = "zM";
      mode = "n";
      options.desc = "Open all folds";
    }
    {
      action.__raw = ''
        function()
          require("ufo").openFoldsExceptKinds()
        end
      '';
      key = "zr";
      mode = "n";
      options.desc = "Open folds";
    }
    {
      action.__raw = ''
        function()
          require("ufo").closeFoldsWith()
        end
      '';
      key = "zm";
      mode = "n";
      options.desc = "Close folds";
    }
    {
      action.__raw = ''
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end
      '';
      key = "K";
      mode = "n";
      options.desc = "Open all folds";
    }
  ]);
in {
  extraPackages = with pkgs;
    lib.optionals pkgs.stdenv.isDarwin [
      pngpaste
    ];
  extraPlugins = with pkgs.vimPlugins; [
    auto-pandoc
    age-secret
    maximize-nvim
    mini-icons
    playground
    vim-gnupg
    vim-indent-object
    vim-table-mode
    Navigator-nvim
  ];
  extraConfigLua = ''
    require("Navigator").setup()
    require("age_secret").setup()
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
    ++ keymapsUfo
    ++ [
      {
        action = mkRaw ''
          function()
            require("Navigator").left()
          end
        '';
        key = "<M-h>";
        options.desc = "Move to left window";
      }
      {
        action = mkRaw ''
          function()
            require("Navigator").down()
          end
        '';
        key = "<M-j>";
        options.desc = "Move to down window";
      }
      {
        action = mkRaw ''
          function()
            require("Navigator").up()
          end
        '';
        key = "<M-k>";
        options.desc = "Move to up window";
      }
      {
        action = mkRaw ''
          function()
            require("Navigator").right()
          end
        '';
        key = "<M-l>";
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
          options.desc = "Toggle Undotree";
        }
      ]
    ));
  plugins = {
    lz-n.plugins = [
      {
        __unkeyed-1 = "maximize-nvim";
        enabled = true;
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
    ];
    auto-session = {
      enable = true;
      lazyLoad.settings.keys = keymap2Lazy keymapsAS;
      settings = {
        auto_save = true;
        auto_restore = false;
      };
    };
    bullets = {
      enable = true;
      settings = {
        checkbox_markers = "✗○◐●✓";
        custom_mappings = [
          ["imap" "<CR>" "<Plug>(bullets-newline)"]
          ["nmap" "o" "<Plug>(bullets-newline)"]
          ["inoremap" "<C-CR>" "<CR>"]
          ["nmap" "gN" "<Plug>(bullets-renumber)"]
          ["vmap" "gN" "<Plug>(bullets-renumber)"]
          ["nmap" "<leader>xk" "<Plug>(bullets-toggle-checkbox)"]
          ["imap" "<C-t>" "<Plug>(bullets-demote)"]
          ["nmap" ">>" "<Plug>(bullets-demote)"]
          ["vmap" ">" "<Plug>(bullets-demote)"]
          ["imap" "<C-d>" "<Plug>(bullets-promote)"]
          ["nmap" "<<" "<Plug>(bullets-promote)"]
          ["vmap" "<" "<Plug>(bullets-promote)"]
        ];
        enable_in_empty_buffers = 0;
        pad_right = 0;
        set_mappings = 0;
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
    dial = {
      enable = true;
      lazyLoad.settings.keys = keymap2Lazy keymapsDial;
      luaConfig.content = ''
        local augend = require('dial.augend')
        require('dial.config').augends:register_group({
          default = {
            augend.integer.alias.decimal,
            augend.integer.alias.hex,
            augend.date.alias['%Y/%m/%d'],
            augend.constant.alias.bool,
            augend.constant.new{
              elements = {"enabled", "disabled"},
              word = true,
              cyclic = true,
            },
            augend.semver.alias.semver,
          },
        })
      '';
    };
    direnv.enable = true;
    helm.enable = true;
    image = {
      enable = true;
      lazyLoad.settings.ft = [
        "markdown"
        "norg"
      ];
      settings = {
        backend = "kitty";
        editor_only_render_when_focused = true;
      };
    };
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
    markdown-preview = {
      enable = true;
      settings.auto_close = 0;
    };
    nvim-bqf.enable = true;
    nvim-ufo = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
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
        before = mkRaw ''
          require("lz.n").trigger_load("telescope")
        '';
      };
      settings = {
        detection_methods = ["pattern" "lsp"];
        scope_chdir = "win";
        show_hidden = true;
      };
    };
    render-markdown = {
      enable = true;
      lazyLoad.settings.ft = "markdown";
      settings = {
        heading.sign = false;
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
    vimwiki = {
      enable = true;
      settings = {
        global_ext = 0;
        filetypes = ["markdown"];
        map_prefix = "<leader>W";
        list = [
          {
            path = mkRaw ''(os.getenv("VIMWIKI_HOME") or os.getenv("HOME")) .. "/vimwiki"'';
            syntax = "markdown";
            ext = ".md";
          }
        ];
      };
    };
    toggleterm = {
      enable = true;
      lazyLoad.settings = {
        keys = keymap2Lazy [
          (mkKeyMap {
            action = "<cmd>ToggleTerm<CR>";
            key = ''<C-\>'';
            options.desc = "ToggleTerm";
          })
        ];
      };
      settings = {
        open_mapping = "[[<C-\\>]]";
        hide_numbers = true;
      };
    };
  };
  userCommands = {
    AutoPandoc = {
      command.__raw = ''
        function()
          require("auto-pandoc").run_pandoc()
        end
      '';
      desc = "Run auto Pandoc";
    };
  };
  my.wKeyList = lib.optionals config.plugins.telescope.enable [
    (wKeyObj ["<leader>q" "" "Session"])
  ];
}
