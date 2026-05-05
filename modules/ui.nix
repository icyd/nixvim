{
  flake.modules.nixvim.ui = {
    lib,
    config,
    pkgs,
    ...
  }: {
    extraPlugins = lib.optional config.plugins.copilot-lua.enable pkgs.local.copilot-lualine;
    plugins = {
      lualine = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
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
            lualine_x =
              (lib.optional config.plugins.overseer.enable "overseer")
              ++ [
                {
                  # typos:disabled
                  __unkeyed-0.__raw = ''require("noice").api.statusline.mode.get'';
                  cond.__raw = ''require("noice").api.statusline.mode.has'';
                  # typos:enabled
                }
                "encoding"
                "fileformat"
                "filetype"
                {
                  __unkeyed-0.__raw = ''
                    function()
                      return vim.t.maximized and "   " or ""
                    end
                  '';
                }
              ];
          };
          winbar = {
            lualine_b = [(listToUnkeyedAttrs ["diagnostics"])];
            lualine_c = lib.mkIf config.plugins.navic.enable [
              (listToUnkeyedAttrs ["navic"])
            ];
            lualine_x =
              (lib.optional config.plugins.copilot-lua.enable (listToUnkeyedAttrs ["copilot"]))
              ++ [
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
      # typos:ignore-next-line
      noice = {
        enable = true;
        settings = {
          cmdline.view = "cmdline";
          presets = {
            bottom_search = true;
            command_palette = false;
            long_message_to_split = true;
            inc_rename = config.plugins.inc-rename.enable;
          };
        };
      };
      notify.enable = true;
      nui.enable = true;
    };
  };
}
