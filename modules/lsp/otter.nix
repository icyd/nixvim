{
  flake.modules.nixvim.lsp = {config, ...}: {
    plugins = {
      otter = {
        inherit (config.plugins.telescope) enable;
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
