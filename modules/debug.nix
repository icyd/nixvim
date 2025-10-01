{
  flake.modules.nixvim.debug = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.plugins.dap;
    inherit (config.utils.mkKey) mkKeyMap wKeyObj;
    inherit (lib.nixvim.utils) mkRaw;
    keymapDAPUI = lib.optionals config.plugins.dap-ui.enable [
      {
        action = mkRaw ''
          function()
            require("dapui").toggle()
          end
        '';
        key = "<leader>du";
        options.desc = "Toggle UI";
      }
    ];
    keymaps = builtins.map mkKeyMap (lib.optionals cfg.enable [
        {
          action = mkRaw ''
            function()
              require("dap").set_breakpoint(vim.fn.input("[Breakpoint condition] > "))
            end
          '';
          key = "<leader>dB";
          options.desc = "Breakpoint condition";
        }
        {
          action = "<cmd>DapToggleBreakpoint<CR>";
          key = "<leader>db";
          options.desc = "Toggle breakpoint";
        }
        {
          action = "<cmd>DapContinue<CR>";
          key = "<leader>dc";
          options.desc = "Continue";
        }
        {
          action = mkRaw ''
            function()
              require("dap").run_to_cursor()
            end
          '';
          key = "<leader>dC";
          options.desc = "Run to cursor";
        }
        {
          action = mkRaw ''
            function()
              require("dap").goto_()
            end
          '';
          key = "<leader>dg";
          options.desc = "Go to line (no execute)";
        }
        {
          action = "<cmd>DapStepInto<CR>";
          key = "<leader>di";
          options.desc = "Step into";
        }
        {
          action = "<cmd>DapStepOut<CR>";
          key = "<leader>do";
          options.desc = "Step out";
        }
        {
          action = "<cmd>DapStepOver<CR>";
          key = "<leader>dO";
          options.desc = "Step over";
        }
        {
          action = mkRaw ''
            function()
              require("dap").up()
            end
          '';
          key = "<leader>dk";
          options.desc = "Go up";
        }
        {
          action = mkRaw ''
            function()
              require("dap").down()
            end
          '';
          key = "<leader>dj";
          options.desc = "Go down";
        }
        {
          action = mkRaw ''
            function()
              require("dap").run_last()
            end
          '';
          key = "<leader>dl";
          options.desc = "Re-run last";
        }
        {
          action = mkRaw ''
            function()
              require("dap").pause()
            end
          '';
          key = "<leader>dp";
          options.desc = "Pause";
        }
        {
          action = "<cmd>DapTerminate<CR>";
          key = "<leader>dq";
          options.desc = "Terminate";
        }
        {
          action = mkRaw ''
            function()
              require("dap").session()
            end
          '';
          key = "<leader>ds";
          options.desc = "Session";
        }
        {
          action = "<cmd>DapToggleRepl<CR>";
          key = "<leader>dr";
          options.desc = "Toggle REPL";
        }
        {
          action = mkRaw ''
            function()
              require("dapui").eval()
            end
          '';
          key = "<leader>de";
          options.desc = "Eval";
        }
        {
          action = mkRaw ''
            function()
              require("dapui").eval(vim.fn.input("[Expression] > "))
            end
          '';
          key = "<leader>dE";
          options.desc = "Eval expression";
        }
        {
          action = mkRaw ''
            function()
              require("dap.ui.widgets").hover()
            end
          '';
          key = "<leader>dw";
          options.desc = "Widgets";
        }
      ]
      ++ keymapDAPUI);
  in {
    extraPlugins = with pkgs.vimPlugins; [
      nvim-dap-cortex-debug
    ];
    extraPackages = with pkgs;
      [
        delve
        lldb
        python312Packages.debugpy
        nodejs-slim
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
    # keymaps = keymapUnlazy keymaps;
    inherit keymaps;
    plugins = {
      cmp-dap = {
        enable = cfg.enable && config.plugins.cmp.enable;
        autoLoad = false;
      };
      dap = {
        enable = true;
        # lazyLoad.settings.cmd = [
        #   "DapNew"
        #   "DapContinue"
        # ];
        luaConfig = {
          pre = ''
            local ok_dap_cortex_debug, dap_cortex_debug = pcall(require, "dap-cortex-debug")
            local rtt_config = ok_dap_cortex_debug and dap_cortex_debug.rtt_config(0) or {}
          '';
          post = ''
            require("dap.ext.vscode").load_launchjs()
            if ok_dap_cortex_debug then
              dap_cortex_debug.setup({
                extension_path = "${pkgs.local.vscode-ext-cortex-debug}/share/vscode/extensions/marus25.cortex-debug",
                dapui_rtt = true,
                dap_vscode_filetypes = { "c", "cpp", "rust" },
                rtt = {
                  buftype = "Terminal"
                },
              })
            end
          '';
        };
        adapters = {
          executables = {
            haskell.command = "haskell-debug-adapter";
            codelldb.command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
            gdb = lib.mkIf pkgs.stdenv.isLinux {
              command = lib.getExe pkgs.gdb;
              args = [
                "-i"
                "dap"
              ];
            };
            lldb.command = lib.getExe' pkgs.lldb "lldb-dap";
          };
        };
        configurations = let
          program = mkRaw ''
            function()
              local default = vim.b.dap_executable or "./"
              local path = vim.fn.input({prompt = "Executable: ", default = default, completion = "file"})
              if path and path ~= "" then
                vim.b.dap_executable = path
                return path
              end
              return require("dap").ABORT
            end
          '';
          rttConfig = mkRaw ''rtt_config'';
          codelldb-config = {
            inherit program;
            type = "codelldb";
            request = "launch";
            name = "Launch (CodeLLDB)";
            cwd = "\${workspaceFolder}";
            stopOnEntry = true;
          };
          openocd-config = {
            inherit rttConfig;
            name = "OpenOCD Launch";
            type = "cortex-debug";
            request = "launch";
            servertype = "openocd";
            runToEntryPoint = "main";
            cwd = "\${workspaceFolder}";
            configFiles = [
              "interface/stlink-v2-1.cfg"
              "target/stm32f3x.cfg"
            ];
            executable = program;
            gdbTarget = "localhost:3333";
            showDevDebugOutput = false;
            postLaunchCommands = [
              "break DefaultHandler"
              "break HardFault"
            ];
          };
          stutil-config = {
            inherit rttConfig;
            name = "STUtil Launch";
            type = "cortex-debug";
            request = "launch";
            servertype = "stutil";
            cwd = "\${workspaceFolder}";
            executable = program;
            runToEntryPoint = "main";
            gdbTarget = "localhost:4242";
            showDevDebugOutput = false;
          };
          bmp-config = {
            inherit rttConfig;
            name = "BMP Launch";
            type = "cortex-debug";
            request = "launch";
            servertype = "bmp";
            runToEntryPoint = "main";
            cwd = "\${workspaceFolder}";
            interface = "swd";
            executable = program;
            BMPGDBSerialPort = "/dev/ttyBmpGdb";
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
            logFile = mkRaw ''
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
              bmp-config
              openocd-config
              stutil-config
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
        inherit (cfg) enable;
        settings.layouts = [
          {
            elements = [
              {
                id = "scopes";
                size = 0.20;
              }
              {
                id = "breakpoints";
                size = 0.20;
              }
              {
                id = "stacks";
                size = 0.20;
              }
              {
                id = "watches";
                size = 0.20;
              }
              {
                id = "rtt";
                size = 0.20;
              }
            ];
            size = 40;
            position = "left";
          }
          {
            elements = [
              "repl"
              "console"
            ];
            size = 20;
            position = "bottom";
          }
        ];
        # lazyLoad.settings = {
        #   before = lazyLoadTrigDAP;
        #   keys = keymap2Lazy keymapDAPUI;
        # };
      };
      dap-virtual-text = {
        inherit (cfg) enable;
        # lazyLoad.settings = {
        #   before = lazyLoadTrigDAP;
        #   cmd = [
        #     "DapVirtualTextToggle"
        #     "DapVirtualTextEnable"
        #   ];
        # };
      };
      dap-go.enable = true;
      dap-lldb.enable = true;
      dap-python.enable = true;
    };
    utils.wKeyList = lib.optionals cfg.enable [
      (wKeyObj ["<leader>d" "󰃤" "Debug"])
    ];
  };
}
