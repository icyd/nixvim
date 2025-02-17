{
  lib,
  config,
  ...
}: {
  plugins = {
    lualine = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      luaConfig.pre = ''
        local function maximize_status()
            return vim.t.maximized and "   " or ""
        end
      '';
      settings = {
        sections = {
          lualine_x.__raw = ''
            {
              "encoding",
              "fileformat",
              "filetype",
              maximize_status,
            }
          '';
        };
        winbar = {
          lualine_b = [
            {
              __unkeyed-0 = "diagnostics";
            }
          ];
          lualine_c = lib.mkIf config.plugins.navic.enable [
            {
              __unkeyed-0 = "navic";
            }
          ];
          lualine_x = [
            {
              __unkeyed-0 = "filename";
              file_status = true;
              newfile_status = true;
              path = 3;
            }
          ];
        };
      };
    };
  };
}
