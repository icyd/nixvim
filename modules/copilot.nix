{
  flake.modules.nixvim.copilot = {
    plugins = {
      copilot-lua = {
        enable = true;
        lazyLoad.settings.event = "InsertEnter";
        settings = {
          panel.enabled = false;
          suggestions.enabled = false;
        };
      };
    };
  };
}
