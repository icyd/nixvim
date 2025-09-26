{
  flake.modules.nixvim.base = {
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
      extraConfigLua = ''
        require("Navigator").setup()
      '';
      extraPlugins = [
        cfg.package
      ];
    };
  };
}
