{
  flake.modules.nixvim.dial = {
    lib,
    config,
    ...
  }: let
    inherit (lib.nixvim.utils) mkRaw;
    inherit (config.utils.mkKey) mkKeyMap keymap2Lazy keymapUnlazy;
    keymaps = builtins.map mkKeyMap [
      {
        action = mkRaw ''
          function()
            require("dial.map").manipulate("increment", "normal")
          end
        '';
        key = "<C-x>";
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
        key = "g<C-x>";
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
        key = "<C-x>";
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
        key = "g<C-x>";
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
  in {
    keymaps = keymapUnlazy keymaps;
    plugins.dial = {
      enable = true;
      lazyLoad.settings.keys = keymap2Lazy keymaps;
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
  };
}
