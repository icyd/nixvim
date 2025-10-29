{
  flake.modules.nixvim.tests = {
    lib,
    config,
    ...
  }: let
    cfg = config.plugins.neotest;
    inherit (config.utils.mkKey) mkKeyMap keymapUnlazy keymap2Lazy wKeyObj;
    inherit (lib.nixvim.utils) mkRaw;
    keymaps = builtins.map mkKeyMap (lib.optionals cfg.enable ([
        {
          action = mkRaw ''
            function()
              require("neotest").run.run()
            end
          '';
          key = "<localleader>tt";
          options.desc = "Run nearest test";
        }
        {
          action = mkRaw ''
            function()
              require("neotest").run.run(vim.fn.expand("%"))
            end
          '';
          key = "<localleader>tf";
          options.desc = "Run test in current file";
        }
        {
          action = mkRaw ''
            function()
              require("neotest").run.run(vim.fn.getcwd())
            end
          '';
          key = "<localleader>td";
          options.desc = "Run test in current directory";
        }
        {
          action = mkRaw ''
            function()
              require("neotest").run.attach()
            end
          '';
          key = "<localleader>ta";
          options.desc = "Attach to nearest test";
        }
        {
          action = mkRaw ''
            function()
              require("neotest").run.stop()
            end
          '';
          key = "<localleader>ts";
          options.desc = "Stop the nearest test";
        }
        {
          action = mkRaw ''
            function()
              require("neotest").watch.toggle(vim.fn.expand("%"))
            end
          '';
          key = "<localleader>tw";
          options.desc = "Toggle watch test in current file";
        }
        {
          action = mkRaw ''
            function()
              require("neotest").summary.toggle()
            end
          '';
          key = "<localleader>tm";
          options.desc = "Toggle test summary window";
        }
        {
          action = mkRaw ''
            function()
              require("neotest").output.open({ enter = true })
            end
          '';
          key = "<localleader>tO";
          options.desc = "Open output of a test result";
        }
        {
          action = mkRaw ''
            function()
              require("neotest").output_panel.toggle()
            end
          '';
          key = "<localleader>to";
          options.desc = "Toggle output panel";
        }
      ]
      ++ (lib.optionals config.plugins.dap.enable [
        {
          action = mkRaw ''
            function()
              require("neotest").run.run({ strategy = "dap" })
            end
          '';
          key = "<localleader>tD";
          options.desc = "Debug the nearest test";
        }
      ])));
  in {
    keymaps = keymapUnlazy keymaps;
    plugins = {
      neotest = {
        enable = true;
        lazyLoad.settings.keys = keymap2Lazy keymaps;
        settings = {
          adapters = lib.optionals config.plugins.rustaceanvim.enable [
            ''require("rustaceanvim.neotest")''
          ];
        };
        adapters = {
          go.enable = true;
          python.enable = true;
          rust.enable = true;
          zig.enable = true;
        };
      };
    };
    utils.wKeyList = lib.optionals cfg.enable [
      (wKeyObj ["<localleader>t" "󰙨" "Neotest"])
    ];
  };
}
