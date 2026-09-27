{
  flake.modules.nixvim.navigation = {config, ...}: let
    inherit (config.utils.mkKey) mkKeyMap;
    keymaps = mkKeyMap [
      {
        action.__raw = ''
          function()
            require("Navigator").left()
          end
        '';
        key = "<M-h>";
        options.desc = "Move to left window";
      }
      {
        action.__raw = ''
          function()
            require("Navigator").down()
          end
        '';
        key = "<M-j>";
        options.desc = "Move to down window";
      }
      {
        action.__raw = ''
          function()
            require("Navigator").up()
          end
        '';
        key = "<M-k>";
        options.desc = "Move to up window";
      }
      {
        action.__raw = ''
          function()
            require("Navigator").right()
          end
        '';
        key = "<M-l>";
        options.desc = "Move to right window";
      }
    ];
  in {
    inherit keymaps;
    plugins = {
      navigator-nvim = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
      };
    };
  };
}
