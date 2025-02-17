{
  lib,
  config,
  ...
}: let
  inherit (config.my.mkKey) keymap2mkKeyMap keymapUnlazy keymap2Lazy;
  cfg = config.plugins.yanky;
  keymaps = keymap2mkKeyMap (lib.optionals cfg.enable [
    {
      action = "<Plug>(YankyPutAfter)<CR>";
      key = "p";
      mode = ["n" "x"];
      options.desc = "Yanky put after";
    }
    {
      action = "<Plug>(YankyPutBefore)<CR>";
      key = "P";
      mode = ["n" "x"];
      options.desc = "Yanky put before";
    }
    {
      action = "<Plug>(YankyGPutAfter)<CR>";
      key = "gp";
      mode = ["n" "x"];
      options.desc = "Yanky put after and move cursor after text";
    }
    {
      action = "<Plug>(YankyGPutBefore)<CR>";
      key = "gP";
      mode = ["n" "x"];
      options.desc = "Yanky put before and move cursor after text";
    }
    {
      action = "<Plug>(YankyPreviousEntry)";
      key = "<C-p>";
      mode = "n";
      options.desc = "Select previous entry in yanky ring";
    }
    {
      action = "<Plug>(YankyNextEntry)";
      key = "<C-n>";
      mode = "n";
      options.desc = "Select next entry in yanky ring";
    }
    {
      action = "<Plug>(YankyPutIndentAfterLinewise)";
      key = "]p";
      mode = "n";
      options.desc = "Yanky put indented after cursor (linewise)";
    }
    {
      action = "<Plug>(YankyPutIndentBeforeLinewise)";
      key = "[p";
      mode = "n";
      options.desc = "Yanky put indented before cursor (linewise)";
    }
    {
      action = "<Plug>(YankyPutIndentAfterLinewise)";
      key = "]P";
      mode = "n";
      options.desc = "Yanky put indented after cursor (linewise)";
    }
    {
      action = "<Plug>(YankyPutIndentBeforeLinewise)";
      key = "[P";
      mode = "n";
      options.desc = "Yanky put indented before cursor (linewise)";
    }
    {
      action = "<Plug>(YankyPutIndentAfterShiftRight)";
      key = ">p";
      mode = "n";
      options.desc = "Yanky put and indent right";
    }
    {
      action = "<Plug>(YankyPutIndentAfterShiftLeft)";
      key = "<p";
      mode = "n";
      options.desc = "Yanky put and indent right";
    }
    {
      action = "<Plug>(YankyPutIndentBeforeShiftRight)";
      key = ">P";
      mode = "n";
      options.desc = "Yanky put before and indent right";
    }
    {
      action = "<Plug>(YankyPutIndentBeforeShiftLeft)";
      key = "<P";
      mode = "n";
      options.desc = "Yanky put before and indent right";
    }
    {
      action = "<Plug>(YankyPutAfterFilter)";
      key = "=p";
      mode = "n";
      options.desc = "Yanky put and indent";
    }
    {
      action = "<Plug>(YankyPutBeforeFilter)";
      key = "=P";
      mode = "n";
      options.desc = "Yanky put before and indent";
    }
  ]);
in {
  keymaps = keymapUnlazy keymaps;
  plugins = {
    sqlite-lua.enable = cfg.enable;
    yanky = {
      enable = true;
      enableTelescope = config.plugins.telescope.enable;
      lazyLoad.settings.keys = keymap2Lazy keymaps;
      settings = {
        ring.storage = "sqlite";
      };
    };
  };
}
