{
  lib,
  config,
  ...
}: {
  autoCmd = lib.optionals config.plugins.firenvim.enable [
    {
      event = "UIEnter";
      callback = lib.nixvim.utils.mkRaw ''
        function(event)
            local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
            if client ~= nil and client.name == "Firenvim" then
                vim.o.laststatus = 0
                vim.o.showtabline = 0
                local ok_lualine, lualine = pcall(require, "lualine")
                if ok_lualine then
                  lualine.hide()
                end
            end
        end
      '';
    }
  ];
  plugins = {
    firenvim = {
      enable = true;
      settings = {
        localSettings = {
          ".*" = {
            cmdline = "neovim";
            content = "text";
            priority = 0;
            selector = "textarea";
            takeover = "never";
          };
        };
      };
    };
  };
}
