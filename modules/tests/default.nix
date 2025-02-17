{
  lib,
  config,
  ...
}: let
  cfg = config.plugins.neotest;
  inherit (config.my.mkKey) keymap2mkKeyMap keymapUnlazy keymap2Lazy wKeyObj;
  keymaps = keymap2mkKeyMap (lib.optionals cfg.enable ([
      {
        action.__raw = ''
          function()
            require("neotest").run.run()
          end
        '';
        key = "<localleader>tt";
        mode = "n";
        options.desc = "Run nearest test";
      }
      {
        action.__raw = ''
          function()
            require("neotest").run.run(vim.fn.expand("%"))
          end
        '';
        key = "<localleader>tf";
        mode = "n";
        options.desc = "Run test in current file";
      }
      {
        action.__raw = ''
          function()
            require("neotest").run.run(vim.fn.getcwd())
          end
        '';
        key = "<localleader>td";
        mode = "n";
        options.desc = "Run test in current directory";
      }
      {
        action.__raw = ''
          function()
            require("neotest").run.attach()
          end
        '';
        key = "<localleader>ta";
        mode = "n";
        options.desc = "Attach to nearest test";
      }
      {
        action.__raw = ''
          function()
            require("neotest").run.stop()
          end
        '';
        key = "<localleader>ts";
        mode = "n";
        options.desc = "Stop the nearest test";
      }
      {
        action.__raw = ''
          function()
            require("neotest").watch.toggle(vim.fn.expand("%"))
          end
        '';
        key = "<localleader>tw";
        mode = "n";
        options.desc = "Toggle watch test in current file";
      }
      {
        action.__raw = ''
          function()
            require("neotest").summary.toggle()
          end
        '';
        key = "<localleader>tm";
        mode = "n";
        options.desc = "Toggle test summary window";
      }
      {
        action.__raw = ''
          function()
            require("neotest").output.open({ enter = true })
          end
        '';
        key = "<localleader>tO";
        mode = "n";
        options.desc = "Open output of a test result";
      }
      {
        action.__raw = ''
          function()
            require("neotest").output_panel.toggle()
          end
        '';
        key = "<localleader>to";
        mode = "n";
        options.desc = "Toggle output panel";
      }
    ]
    ++ (lib.optionals config.plugins.dap.enable [
      {
        action.__raw = ''
          function()
            require("neotest").run.run({ strategy = "dap" })
          end
        '';
        key = "<localleader>tD";
        mode = "n";
        options.desc = "Debug the nearest test";
      }
    ])));
in {
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
        go.enable = cfg.enable;
        python.enable = cfg.enable;
        rust.enable = cfg.enable && !config.plugins.rustaceanvim.enable;
        zig.enable = cfg.enable;
      };
    };
  };
  keymaps = keymapUnlazy keymaps;
  my.wKeyList = lib.optionals cfg.enable [
    (wKeyObj ["<localleader>t" "󰙨" "Neotest"])
  ];
}
