{
  flake.modules.nixvim.navigation = {config, ...}: let
    inherit (config.utils.mkKey) mkKeyMap;
    keymaps = mkKeyMap [
      {
        action.__raw = ''
          function()
            require("smart-splits").move_cursor_left()
          end
        '';
        key = "<M-h>";
        options.desc = "Move to left window";
      }
      {
        action.__raw = ''
          function()
            require("smart-splits").move_cursor_down()
          end
        '';
        key = "<M-j>";
        options.desc = "Move to down window";
      }
      {
        action.__raw = ''
          function()
            require("smart-splits").move_cursor_up()
          end
        '';
        key = "<M-k>";
        options.desc = "Move to up window";
      }
      {
        action.__raw = ''
          function()
            require("smart-splits").move_cursor_right()
          end
        '';
        key = "<M-l>";
        options.desc = "Move to right window";
      }
      {
        action.__raw = ''
          function()
            require("smart-splits").resize_left()
          end
        '';
        key = "<M-S-l>";
        options.desc = "Resize to left";
      }
      {
        action.__raw = ''
          function()
            require("smart-splits").resize_down()
          end
        '';
        key = "<M-S-j>";
        options.desc = "Resize to down";
      }
      {
        action.__raw = ''
          function()
            require("smart-splits").resize_up()
          end
        '';
        key = "<M-S-k>";
        options.desc = "Resize to up";
      }
      {
        action.__raw = ''
          function()
            require("smart-splits").resize_right()
          end
        '';
        key = "<M-S-l>";
        options.desc = "Resize to right";
      }
    ];
  in {
    inherit keymaps;
    plugins = {
      smart-splits = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
      };
    };
  };
}
