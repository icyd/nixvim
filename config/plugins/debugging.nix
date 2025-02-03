{ pkgs, lib, ... }:
{
  extraPackages = with pkgs; [
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
  keymaps = [
    {
      action.__raw = ''
        function()
          require("dap").set_breakpoint(vim.fn.intput("[Breakpoint condition] > "))
        end
      '';
      key = "<leader>dB";
      mode = "n";
      options.desc = "Breakpoint condition";
      options.silent = true;
    }
    {
      action = "<cmd>DapToggleBreakpoint<CR>";
      key = "<leader>db";
      mode = "n";
      options.desc = "Toggle breakpoint";
      options.silent = true;
    }
    {
      action = "<cmd>DapContinue<CR>";
      key = "<leader>dc";
      mode = "n";
      options.desc = "Continue";
      options.silent = true;
    }
    {
      action.__raw = ''
          require("dap").run_to_cursor
      '';
      key = "<leader>dC";
      mode = "n";
      options.desc = "Run to cursor";
      options.silent = true;
    }
    {
      action.__raw = ''
          require("dap").goto_
      '';
      key = "<leader>dg";
      mode = "n";
      options.desc = "Go to line (no execute)";
      options.silent = true;
    }
    {
      action = "<cmd>DapStepInto<CR>";
      key = "<leader>di";
      mode = "n";
      options.desc = "Step into";
      options.silent = true;
    }
    {
      action = "<cmd>DapStepOut<CR>";
      key = "<leader>do";
      mode = "n";
      options.desc = "Step out";
      options.silent = true;
    }
    {
      action = "<cmd>DapStepOver<CR>";
      key = "<leader>dO";
      mode = "n";
      options.desc = "Step over";
      options.silent = true;
    }
    {
      action.__raw = ''
          require("dap").up
      '';
      key = "<leader>dk";
      mode = "n";
      options.desc = "Go up";
      options.silent = true;
    }
    {
      action.__raw = ''
          require("dap").down
      '';
      key = "<leader>dj";
      mode = "n";
      options.desc = "Go down";
      options.silent = true;
    }
    {
      action.__raw = ''
          require("dap").run_last
      '';
      key = "<leader>dl";
      mode = "n";
      options.desc = "Re-run last";
      options.silent = true;
    }
    {
      action.__raw = ''
          require("dap").pause
      '';
      key = "<leader>dp";
      mode = "n";
      options.desc = "Pause";
      options.silent = true;
    }
    {
      action = "<cmd>DapTerminate<CR>";
      key = "<leader>dq";
      mode = "n";
      options.desc = "Terminate";
      options.silent = true;
    }
    {
      action.__raw = ''
          require("dap").session
      '';
      key = "<leader>ds";
      mode = "n";
      options.desc = "Session";
      options.silent = true;
    }
    {
      action = "<cmd>DapToggleRepl<CR>";
      key = "<leader>dr";
      mode = "n";
      options.desc = "Toggle REPL";
      options.silent = true;
    }
    {
      action.__raw = ''
          require("dapui").toggle
      '';
      key = "<leader>du";
      mode = "n";
      options.desc = "Toggle UI";
      options.silent = true;
    }
    {
      action.__raw = ''
          require("dapui").eval
      '';
      key = "<leader>de";
      mode = "n";
      options.desc = "Eval";
      options.silent = true;
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
      options.silent = true;
    }{
      action.__raw = ''
          require("dap.ui.widgets").hover
      '';
      key = "<leader>dw";
      mode = "n";
      options.desc = "Widgets";
      options.silent = true;
    }
  ];
  plugins = {
    cmp-dap.enable = true;
    dap = {
      enable = true;
      adapters = {
        executables = {
          haskell.command = "haskell-debug-adapter";
          gdb = {
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
        lldb-config = codelldb-config // {
          type = "lldb";
          name = "Launch (LLDB)";
        };
        gdb-config = codelldb-config // {
          type = "gdb";
          name = "Launch (GDB)";
        };
        haskell-config = rec {
          type = "haskell";
          request = "launch";
          name = "Lauch (Haskell)";
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
        c = [
          lldb-config
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          gdb-config
        ];
        cpp = c ++ [
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
    dap-ui.enable = true;
    dap-virtual-text.enable = true;
    dap-go.enable = true;
    dap-lldb.enable = true;
    dap-python.enable = true;
  };
}
