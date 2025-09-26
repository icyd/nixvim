{
  flake.modules.nixvim.navigator = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap;
    inherit (lib.nixvim.utils) mkRaw;
    keymaps = builtins.map mkKeyMap [
      {
        action = mkRaw ''
          function()
            if os.getenv("ZELLIJ") then
              require("zellij-nav").left()
            else
              require("Navigator").left()
            end
          end
        '';
        key = "<M-h>";
        options.desc = "Move to left window";
      }
      {
        action = mkRaw ''
          function()
            if os.getenv("ZELLIJ") then
              require("zellij-nav").down()
            else
              require("Navigator").down()
            end
          end
        '';
        key = "<M-j>";
        options.desc = "Move to down window";
      }
      {
        action = mkRaw ''
          function()
            if os.getenv("ZELLIJ") then
              require("zellij-nav").up()
            else
              require("Navigator").up()
            end
          end
        '';
        key = "<M-k>";
        options.desc = "Move to up window";
      }
      {
        action = mkRaw ''
          function()
            if os.getenv("ZELLIJ") then
              require("zellij-nav").right()
            else
              require("Navigator").right()
            end
          end
        '';
        key = "<M-l>";
        options.desc = "Move to right window";
      }
    ];
  in {
    inherit keymaps;
    autoCmd = lib.optional config.plugins.zellij-nav.enable {
      command = "silent !zellij action switch-mode normal";
      desc = "Switch Zellij mode to normal when leaving nvim";
      event = "VimLeave";
      pattern = "*";
    };
    plugins = {
      navigator-nvim.enable = true;
      zellij-nav = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
      };
    };
  };
}
