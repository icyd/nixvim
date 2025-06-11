{
  flake.modules.nixvim.ufo = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap;
    keymaps = builtins.map mkKeyMap (lib.optionals config.plugins.nvim-ufo.enable [
      {
        action.__raw = ''
          function()
            require("ufo").openAllFolds()
          end
        '';
        key = "zR";
        mode = "n";
        options.desc = "Open all folds";
      }
      {
        action.__raw = ''
          function()
            require("ufo").closeAllFolds()
          end
        '';
        key = "zM";
        mode = "n";
        options.desc = "Open all folds";
      }
      {
        action.__raw = ''
          function()
            require("ufo").openFoldsExceptKinds()
          end
        '';
        key = "zr";
        mode = "n";
        options.desc = "Open folds";
      }
      {
        action.__raw = ''
          function()
            require("ufo").closeFoldsWith()
          end
        '';
        key = "zm";
        mode = "n";
        options.desc = "Close folds";
      }
      {
        action.__raw = ''
          function()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            if not winid then
              vim.lsp.buf.hover()
            end
          end
        '';
        key = "K";
        mode = "n";
        options.desc = "Open all folds";
      }
    ]);
  in {
    inherit keymaps;
    plugins.nvim-ufo = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
  };
}
