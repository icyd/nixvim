{
  flake.modules.nixvim.tests = {
    lib,
    config,
    ...
  }: let
    cfg = config.plugins.neotest;
    inherit (config.utils.mkKey) mkKeyMapIf wKeyObjMapIf keymapUnlazy keymap2Lazy;
    keymaps =
      mkKeyMapIf cfg.enable [
        {
          action.__raw = ''
            function()
              require("neotest").run.run()
            end
          '';
          key = "<localleader>tt";
          options.desc = "Run nearest test";
        }
        {
          action.__raw = ''
            function()
              require("neotest").run.run(vim.fn.expand("%"))
            end
          '';
          key = "<localleader>tf";
          options.desc = "Run test in current file";
        }
        {
          action.__raw = ''
            function()
              require("neotest").run.run(vim.fn.getcwd())
            end
          '';
          key = "<localleader>td";
          options.desc = "Run test in current directory";
        }
        {
          action.__raw = ''
            function()
              require("neotest").run.attach()
            end
          '';
          key = "<localleader>ta";
          options.desc = "Attach to nearest test";
        }
        {
          action.__raw = ''
            function()
              require("neotest").run.stop()
            end
          '';
          key = "<localleader>ts";
          options.desc = "Stop the nearest test";
        }
        {
          action.__raw = ''
            function()
              require("neotest").watch.toggle(vim.fn.expand("%"))
            end
          '';
          key = "<localleader>tw";
          options.desc = "Toggle watch test in current file";
        }
        {
          action.__raw = ''
            function()
              require("neotest").summary.toggle()
            end
          '';
          key = "<localleader>tm";
          options.desc = "Toggle test summary window";
        }
        {
          action.__raw = ''
            function()
              require("neotest").output.open({ enter = true })
            end
          '';
          key = "<localleader>tO";
          options.desc = "Open output of a test result";
        }
        {
          action.__raw = ''
            function()
              require("neotest").output_panel.toggle()
            end
          '';
          key = "<localleader>to";
          options.desc = "Toggle output panel";
        }
      ]
      ++ (
        lib.optional config.plugins.dap.enable {
          action.__raw = ''
            function()
              require("neotest").run.run({ strategy = "dap" })
            end
          '';
          key = "<localleader>tD";
          options.desc = "Debug the nearest test";
        }
      )
      ++ (lib.optional config.plugins.overseer.enable {
        action.__raw = ''
          function()
            require("neotest").overseer.run()
          end
        '';
        key = "<localleader>tv";
        options.desc = "Run nearest test with Overseer";
      });
  in {
    keymaps = keymapUnlazy keymaps;
    plugins = {
      neotest = {
        enable = true;
        lazyLoad.settings = {
          before = lib.mkIf config.plugins.rustaceanvim.enable {
            __raw = ''
              function()
                require("lz.n").trigger_load("overseer.nvim")
              end
            '';
          };
          cmd = [
            "Neotest"
          ];

          keys = keymap2Lazy keymaps;
        };
        settings =
          {
            adapters = lib.optional config.plugins.rustaceanvim.enable {
              __raw = ''require("rustaceanvim.neotest")'';
            };
          }
          // (lib.optionalAttrs config.plugins.overseer.enable {
            consumers.overseer.__raw = ''
              require("neotest.consumers.overseer")
            '';
            overseer = {
              enabled = true;
              force_default = false;
            };
          });
        adapters = {
          golang.enable = true;
          python.enable = true;
          rust.enable = !config.plugins.rustaceanvim.enable;
        };
      };
    };
    utils.wKeyList = wKeyObjMapIf cfg.enable [
      ["<localleader>t" "󰙨" "Neotest"]
    ];
  };
}
