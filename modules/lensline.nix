{
  flake.modules.nixvim.lensline = {config, ...}: let
    cfg = config.plugins.neotest;
    inherit (config.utils.mkKey) mkKeyMapIf;
    keymaps = mkKeyMapIf cfg.enable [
      {
        action = "<cmd>LenslineToggleView<CR>";
        key = "<leader>ueL";
        options.desc = "Lensline engine toggle";
      }
      {
        action = "<cmd>LenslineToggleView<CR>";
        key = "<leader>uel";
        options.desc = "Lensline view toggle";
      }
    ];
  in {
    inherit keymaps;
    plugins.lensline = {
      enable = true;
      lazyLoad.settings.event = [
        "BufReadPost"
        "BufNewFile"
      ];
      settings = {
        profiles = [
          {
            name = "default";
            providers = [
              {
                name = "usages";
                enabled = true;
                include = ["refs"];
                breakdown = false;
                show_zero = false;
              }
              {
                name = "last_author";
                enabled = false;
                cache_max_files = 100;
              }
              {
                name = "diagnostics";
                enabled = true;
                min_level = "HINT";
              }
              {
                name = "complexity";
                enabled = true;
                min_level = "L";
              }
            ];
          }
        ];
      };
    };
  };
}
