{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.plugins.dap;
  inherit (config.my.mkKey) mkKeyMap keymapUnlazy keymap2Lazy wKeyObj;
  lazyLoadTrigDAP = ''
    function()
      require("lz.n").trigger_load("nvim-dap")
    end
  '';
  keymaps = builtins.map mkKeyMap (lib.optionals cfg.enable [
    {
      action.__raw = ''
        function()
          require("dap").set_breakpoint(vim.fn.input("[Breakpoint condition] > "))
        end
      '';
      key = "<leader>dB";
      mode = "n";
      options.desc = "Breakpoint condition";
    }
    {
      action = "<cmd>DapToggleBreakpoint<CR>";
      key = "<leader>db";
      mode = "n";
      options.desc = "Toggle breakpoint";
    }
    {
      action = "<cmd>DapContinue<CR>";
      key = "<leader>dc";
      mode = "n";
      options.desc = "Continue";
    }
    {
      action.__raw = ''
        function()
          require("dap").run_to_cursor()
        end
      '';
      key = "<leader>dC";
      mode = "n";
      options.desc = "Run to cursor";
    }
    {
      action.__raw = ''
        function()
          require("dap").goto_()
        end
      '';
      key = "<leader>dg";
      mode = "n";
      options.desc = "Go to line (no execute)";
    }
    {
      action = "<cmd>DapStepInto<CR>";
      key = "<leader>di";
      mode = "n";
      options.desc = "Step into";
    }
    {
      action = "<cmd>DapStepOut<CR>";
      key = "<leader>do";
      mode = "n";
      options.desc = "Step out";
    }
    {
      action = "<cmd>DapStepOver<CR>";
      key = "<leader>dO";
      mode = "n";
      options.desc = "Step over";
    }
    {
      action.__raw = ''
        function()
          require("dap").up()
        end
      '';
      key = "<leader>dk";
      mode = "n";
      options.desc = "Go up";
    }
    {
      action.__raw = ''
        function()
          require("dap").down()
        end
      '';
      key = "<leader>dj";
      mode = "n";
      options.desc = "Go down";
    }
    {
      action.__raw = ''
        function()
          require("dap").run_last()
        end
      '';
      key = "<leader>dl";
      mode = "n";
      options.desc = "Re-run last";
    }
    {
      action.__raw = ''
        function()
          require("dap").pause()
        end
      '';
      key = "<leader>dp";
      mode = "n";
      options.desc = "Pause";
    }
    {
      action = "<cmd>DapTerminate<CR>";
      key = "<leader>dq";
      mode = "n";
      options.desc = "Terminate";
    }
    {
      action.__raw = ''
        function()
          require("dap").session()
        end
      '';
      key = "<leader>ds";
      mode = "n";
      options.desc = "Session";
    }
    {
      action = "<cmd>DapToggleRepl<CR>";
      key = "<leader>dr";
      mode = "n";
      options.desc = "Toggle REPL";
    }
    {
      action.__raw = ''
        function()
          require("dapui").toggle()
        end
      '';
      key = "<leader>du";
      mode = "n";
      options.desc = "Toggle UI";
    }
    {
      action.__raw = ''
        function()
          require("dapui").eval()
        end
      '';
      key = "<leader>de";
      mode = "n";
      options.desc = "Eval";
    }
    {
      action.__raw = ''
        function()
          require("dapui").eval(vim.fn.input("[Expression] > "))
        end
      '';
      key = "<leader>dE";
      mode = "n";
      options.desc = "Eval expression";
    }
    {
      action.__raw = ''
        function()
          require("dap.ui.widgets").hover()
        end
      '';
      key = "<leader>dw";
      mode = "n";
      options.desc = "Widgets";
    }
  ]);
in {
  extraPackages = with pkgs;
    [
      delve
      lldb
      python312Packages.debugpy
    ]
    ++ (with pkgs.haskellPackages; [
      fast-tags
      ghci-dap
      haskell-language-server
      haskell-debug-adapter
      hoogle
    ])
    ++ (lib.optionals pkgs.stdenv.isLinux [
      gdb
    ]);
  keymaps = keymapUnlazy keymaps;
  plugins = {
    lz-n.plugins = lib.optionals (cfg.enable && config.plugins.cmp.enable) [
      {
        __unkeyed-1 = "cmp-dap";
        event = "BufReadPre";
      }
    ];
    cmp-dap = {
      enable = cfg.enable && config.plugins.cmp.enable;
      autoLoad = false;
    };
    dap = {
      enable = true;
      lazyLoad.settings = {
        cmd = [
          "DapNew"
          "DapContinue"
        ];
        keys = keymap2Lazy keymaps;
      };
      adapters = {
        executables = {
          haskell.command = "haskell-debug-adapter";
          gdb = lib.mkIf pkgs.stdenv.isLinux {
            command = lib.getExe pkgs.gdb;
            args = [
              "-i"
              "dap"
            ];
          };
          lldb.command = lib.getExe' pkgs.lldb "lldb-dap";
        };
        servers = {
          codelldb = {
            port = "\${port}";
            executable = {
              command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
              args = [
                "--port"
                "\${port}"
              ];
            };
          };
        };
      };
      configurations = let
        program.__raw = ''
          function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end
        '';
        codelldb-config = {
          inherit program;
          type = "codelldb";
          request = "launch";
          name = "Launch (CodeLLDB)";
          cwd = "\${workspaceFolder}";
          stopOnEntry = true;
        };
        lldb-config =
          codelldb-config
          // {
            type = "lldb";
            name = "Launch (LLDB)";
          };
        gdb-config =
          codelldb-config
          // {
            type = "gdb";
            name = "Launch (GDB)";
          };
        haskell-config = rec {
          type = "haskell";
          request = "launch";
          name = "Launch (Haskell)";
          workspace = "\${workspaceFolder}";
          stopOnEntry = true;
          logFile.__raw = ''
            vim.fn.stdpath("data") .. "/haskell-dap.log"
          '';
          logLevel = "WARNING";
          ghciEnv = {};
          ghciPrompt = "ghci> ";
          ghciInitialPrompt = ghciPrompt;
          ghciCmd = "ghci-dap --interactive -i -i\${workspaceFolder}";
        };
      in rec {
        c =
          [
            lldb-config
          ]
          ++ lib.optionals pkgs.stdenv.isLinux [
            gdb-config
          ];
        cpp =
          c
          ++ [
            codelldb-config
          ];
        rust = cpp;
        haskell = [
          haskell-config
        ];
      };
      signs = {
        dapBreakpoint = {
          text = "";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "";
          texthl = "dapBreakpointCondition";
        };
        dapBreakpointRejected = {
          text = "";
          texthl = "DapBreakpointRejected";
        };
        dapLogPoint = {
          text = "";
          texthl = "DapLogPoint";
        };
        dapStopped = {
          text = "";
          texthl = "DapStopped";
        };
      };
    };
    dap-ui = {
      enable = cfg.enable;
      lazyLoad.settings.before.__raw = lazyLoadTrigDAP;
    };
    dap-virtual-text = {
      enable = cfg.enable;
      lazyLoad.settings.before.__raw = lazyLoadTrigDAP;
    };
    dap-go.enable = true;
    dap-lldb.enable = true;
    dap-python.enable = true;
  };
  my.wKeyList = lib.optionals cfg.enable [
    (wKeyObj ["<leader>d" "󰃤" "Debug"])
  ];
}
