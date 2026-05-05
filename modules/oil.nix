{
  flake.modules.nixvim.oil = {config, ...}: let
    inherit (config.utils.mkKey) mkKeyMapIf;
    keymaps = mkKeyMapIf config.plugins.oil.enable [
      {
        action = "<cmd>Oil<CR>";
        key = "<leader>uo";
        options.desc = "Open Oil file browser";
      }
    ];
  in {
    inherit keymaps;
    plugins.oil = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
  };
}
