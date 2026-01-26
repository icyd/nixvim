{
  flake.modules.nixvim.lsp = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap;
    inherit (lib.nixvim.utils) mkRaw;
  in {
    keymaps = builtins.map mkKeyMap [
      {
        action = mkRaw ''
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
        # inherit (config.plugins.telescope) enable;
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
