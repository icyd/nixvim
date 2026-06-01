{
  flake.modules.nixvim.copilot = {
    plugins = {
      copilot-chat = {
        enable = false;
        lazyLoad.settings.cmd = [
          "CopilotChat"
          "CopilotChatOpen"
        ];
      };
      copilot-lua = {
        enable = false;
        lazyLoad.settings.event = "InsertEnter";
        settings = {
          panel.enabled = false;
          suggestions.enabled = false;
        };
      };
    };
  };
}
