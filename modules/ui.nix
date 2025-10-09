{
  flake.modules.nixvim.ui = {
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
        settings = with lib.nixvim.utils; {
          options.disabled_filetypes.winbar = [
            "dap-repl"
            "dapui_console"
            "dapui_watches"
            "dapui_stacks"
            "dapui_breakpoints"
            "dapui_scopes"
          ];
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
      snacks.settings = let
        cfg = config.plugins.snacks;
      in {
        input.enabled = cfg.enable;
        notifier.enabled = cfg.enable;
        picker.enabled = cfg.enable;
      };
    };
  };
}
