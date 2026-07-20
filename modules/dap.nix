{
  nixpkgs.allowedUnfreePackages = [
    "vscode-extension-ms-vscode-cpptools"
  ];
  flake.modules.nixvim.debug = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.plugins.dap;
    inherit (config.utils.mkKey) mkKeyMapIf wKeyObjMapIf keymap2Lazy keymapUnlazy;
    keysDapUi = mkKeyMapIf config.plugins.dap-ui.enable [
      {
        action.__raw = ''
          function()
            require("dapui").toggle()
          end
        '';
        key = "<leader>du";
        options.desc = "Toggle UI";
      }
    ];
    keymaps = mkKeyMapIf cfg.enable [
      {
        action.__raw = ''
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
        action.__raw = ''
          function()
            require("dap").run_to_cursor()
          end
        '';
        key = "<leader>dC";
        options.desc = "Run to cursor";
      }
      {
        action.__raw = ''
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
        action.__raw = ''
          function()
            require("dap").up()
          end
        '';
        key = "<leader>dk";
        options.desc = "Go up";
      }
      {
        action.__raw = ''
          function()
            require("dap").down()
          end
        '';
        key = "<leader>dj";
        options.desc = "Go down";
      }
      {
        action.__raw = ''
          function()
            require("dap").run_last()
          end
        '';
        key = "<leader>dl";
        options.desc = "Re-run last";
      }
      {
        action.__raw = ''
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
        action.__raw = ''
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
        action.__raw = ''
          function()
            require("dapui").eval()
          end
        '';
        key = "<leader>de";
        options.desc = "Eval";
      }
      {
        action.__raw = ''
          function()
            require("dapui").eval(vim.fn.input("[Expression] > "))
          end
        '';
        key = "<leader>dE";
        options.desc = "Eval expression";
      }
      {
        action.__raw = ''
          function()
            require("dap.ui.widgets").hover()
          end
        '';
        key = "<leader>dw";
        options.desc = "Widgets";
      }
    ];
    cpptools-patched = pkgs.vscode-extensions.ms-vscode.cpptools.overrideAttrs (prev: {
      postInstall =
        (prev.postInstall or "")
        + ''
          DIR="$out/share/vscode/extensions/ms-vscode.cpptools/debugAdapters/bin"

          if [ -d "$DIR" ]; then
            ln -s "$DIR/cppdbg.ad7Engine.json" "$DIR/nvim-dap.ad7Engine.json"
          fi
        '';
    });
  in {
    extraPlugins = with pkgs.vimPlugins; [
      nvim-dap-cortex-debug
    ];
    extraPackages = with pkgs;
      lib.optionals cfg.enable (
        [
          nodejs
          lldb
          python312Packages.debugpy
          # vscode-extensions.ms-vscode.cpptools
          cpptools-patched
          local.vscode-ext-cortex-debug
        ]
        ++ (lib.optional pkgs.stdenv.isLinux gdb)
      );
    keymaps = keymapUnlazy (keymaps ++ keysDapUi);
    plugins = {
      dap = {
        enable = true;
        lazyLoad.settings.keys = keymap2Lazy keymaps;
        lazyLoad.settings.before.__raw = ''
          function()
            require("lz.n").trigger_load("nvim-dap-iu")
            require("lz.n").trigger_load("nvim-dap-virtual-text")
            local overseer, overseer_ok = pcall(require, "overseer")
            if overseer_ok then
              overseer.enable_dap()
            end
          end
        '';
        luaConfig = {
          pre = ''
            local ok_dap_cortex_debug, dap_cortex_debug = pcall(require, "dap-cortex-debug")
            local rtt_config = ok_dap_cortex_debug and dap_cortex_debug.rtt_config(0) or {}
          '';
          post = ''
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
            gdb = lib.mkIf pkgs.stdenv.isLinux {
              command = lib.getExe pkgs.gdb;
              args = [
                "-i"
                "dap"
              ];
            };
            lldb.command = lib.getExe' pkgs.lldb "lldb-dap";
            codelldb.command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
            cppdbg.command = "${cpptools-patched}/share/vscode/extensions/ms-vscode.cpptools/debugAdapters/bin/OpenDebugAD7";
          };
        };
        configurations = let
          program.__raw = ''
            function()
              local default = vim.b.dap_executable or vim.fn.getcwd() .. "/"
              local path = vim.fn.input({prompt = "Executable: ", default = default, completion = "file"})
              if path and path ~= "" then
                local trim_path = vim.trim(path)
                vim.b.dap_executable = trim_path
                return trim_path
              end
              return require("dap").ABORT
            end
          '';
          rttConfig.__raw = "rtt_config";
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
          cppdbg-config =
            codelldb-config
            // {
              type = "cppdbg";
              name = "Launch (cpptools)";
            };
          gdb-config =
            codelldb-config
            // {
              type = "gdb";
              name = "Launch (GDB)";
            };
        in rec {
          cpp = [
            lldb-config
            codelldb-config
            cppdbg-config
          ];
          c =
            cpp
            ++ lib.optionals pkgs.stdenv.isLinux [
              gdb-config
              bmp-config
              openocd-config
              stutil-config
            ];
          rust = [
            codelldb-config
            cppdbg-config
            (lldb-config
              // {
                initCommands.__raw = ''
                  function()
                    local rustc_sysroot = vim.fn.trim(vim.fn.system 'rustc --print sysroot')
                    assert(
                      vim.v.shell_error == 0,
                      'failed to get rust sysroot using `rustc --print sysroot`: '
                        .. rustc_sysroot
                    )
                    local script_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py'
                    local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'
                    return {
                      ([[!command script import '%s']]):format(script_file),
                      ([[command source '%s']]):format(commands_file),
                    }
                  end
                '';
              })
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
        lazyLoad.settings = {
          before.__raw = ''
            function()
              require("lz.n").trigger_load("nvim-dap")
              require("lz.n").trigger_load("nvim-virtual-text")
            end
          '';
          keys = keymap2Lazy (keymaps ++ keysDapUi);
        };
        luaConfig.post = ''
          local dap, dapui = require("dap"), require("dapui")
          dap.listeners.before.attach.dapui_config = function()
            dapui.open()
          end
          dap.listeners.before.launch.dapui_config = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
          end
          dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
          end
        '';
      };
      dap-virtual-text = {
        inherit (cfg) enable;
        lazyLoad.settings = {
          before.__raw = ''
            function()
              require("lz.n").trigger_load("nvim-dap")
            end
          '';
          cmd = [
            "DapVirtualTextToggle"
            "DapVirtualTextEnable"
            "DapVirtualTextForceRefresh"
          ];
        };
      };
      dap-go = {
        enable = true;
        settings.delve.path = "${lib.getExe pkgs.delve}";
      };
      # dap-lldb.enable = true;
      dap-python.enable = true;
      debugprint = {
        enable = true;
        lazyLoad.settings = {
          cmd = "Debugprint";
          keys = ["g?"];
        };
      };
    };
    utils.wKeyList = wKeyObjMapIf cfg.enable [
      ["<leader>d" "󰃤" "Debug"]
    ];
  };
}
