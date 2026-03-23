{
  flake.modules.nixvim.copilot = {
    plugins = {
      copilot-chat = {
        enable = true;
        lazyLoad.settings.cmd = [
          "CopilotChat"
          "CopilotChatOpen"
        ];
      };
      copilot-lua = {
        enable = true;
        lazyLoad.settings.event = "InsertEnter";
        settings = {
          panel.enabled = false;
          suggestions.enabled = false;
        };
      };
    };
    # utils.wKeyList = lib.optionals config.plugins.openscad.enable [
    #   (wKeyObj ["<leader>p" "󰶓" "Copilot"])
    # ];
  };
}
