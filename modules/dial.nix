{
  flake.modules.nixvim.dial = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) keymapUnlazy keymap2Lazy;
    inherit (lib.nixvim.utils) mkRaw;
    keymaps = [
      {
        action = mkRaw ''
          function()
            require("dial.map").inc_normal()
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
            require("dial.map").dec_normal()
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
            require("dial.map").inc_gnormal()
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
            require("dial.map").dec_gnormal()
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
            require("dial.map").inc_visual()
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
            require("dial.map").dec_visual()
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
            require("dial.map").inc_gvisual()
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
            require("dial.map").dec_gvisual()
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
