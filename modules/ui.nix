{
  flake.modules.nixvim.ui = {
    lib,
    config,
    ...
  }: {
    plugins = {
      dressing = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings.input.mapping.n = {
          "q" = "Close";
          "k" = "HistoryPrev";
          "j" = "HistoryNext";
        };
      };
      lualine = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        luaConfig.pre = ''
          local function maximize_status()
              return vim.t.maximized and "   " or ""
          end
        '';
        settings = with lib.nixvim.utils; {
          sections = {
            lualine_x = mkRaw ''
              {
                "encoding",
                "fileformat",
                "filetype",
                maximize_status,
              }
            '';
          };
          winbar = {
            lualine_b = [(listToUnkeyedAttrs ["diagnostics"])];
            lualine_c = lib.mkIf config.plugins.navic.enable [
              (listToUnkeyedAttrs ["navic"])
            ];
            lualine_x = [
              ((listToUnkeyedAttrs ["filename"])
                // {
                  file_status = true;
                  newfile_status = true;
                  path = 3;
                })
            ];
          };
        };
      };
      notify = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
      };
    };
  };
}
