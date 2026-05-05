{
  flake.modules.nixvim.core = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.plugins.luasnip-snippets;
  in {
    options.plugins.luasnip-snippets = {
      enable = lib.mkEnableOption "luasnip-snippets";
      package = lib.mkPackageOption pkgs.local "luasnip-snippets" {};
    };
    config = lib.mkIf (cfg.enable
      && config.plugins.luasnip.enable) {
      extraPlugins = [
        cfg.package
      ];
      plugins.lz-n.plugins = lib.mkIf config.plugins.lz-n.enable [
        {
          __unkeyed-1 = "luasnip-snippets";
          enabled = true;
          event = "InsertEnter";
          before.__raw = ''
            function()
              require("lz.n").trigger_load("luasnip")
            end
          '';
          after.__raw = ''
            function()
              require("luasnip_snippets.common.snip_utils").setup()
            end
          '';
        }
      ];
    };
  };
}
