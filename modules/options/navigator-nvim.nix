{
  flake.modules.nixvim.core = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.plugins.navigator-nvim;
  in {
    options.plugins.navigator-nvim = {
      enable = lib.mkEnableOption "navigator-nvim";
      package = lib.mkPackageOption pkgs.vimPlugins "Navigator-nvim" {};
    };
    config = lib.mkIf cfg.enable {
      extraPlugins = [
        cfg.package
      ];
      plugins.lz-n.plugins = [
        {
          __unkeyed-1 = "navigator-nvim";
          enabled = true;
          event = "DeferredUIEnter";
          after.__raw = ''
            function()
              require("Navigator").setup({})
            end
          '';
        }
      ];
    };
  };
}
