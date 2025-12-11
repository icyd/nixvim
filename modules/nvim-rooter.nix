{
  flake.modules.nixvim.nvim-rooter = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib.nixvim.utils) mkRaw;
  in {
    extraPlugins = with pkgs; [
      local.nvim-rooter
    ];
    plugins.lz-n.plugins = [
      {
        __unkeyed-1 = "nvim-rooter";
        event = "DeferredUIEnter";
        after = mkRaw ''
          require("nvim-rooter").setup()
        '';
      }
    ];
  };
}
