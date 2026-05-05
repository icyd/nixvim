{
  flake.modules.nixvim.lsp = {config, ...}: let
    inherit (config.utils.mkKey) mkKeyMap;
  in {
    keymaps = mkKeyMap [
      {
        action.__raw = ''
          function()
            require("otter").activate()
          end
        '';
        key = "<leader>lO";
        options.desc = "Activate Otter";
      }
    ];
    plugins = {
      otter = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        autoActivate = false;
        settings = {
          buffers.set_filetype = true;
          handle_leading_whitespace = true;
          lsp.diagnostic_update_events = [
            "BufWritePost"
            "InsertLeave"
            "TextChanged"
          ];
        };
      };
    };
  };
}
