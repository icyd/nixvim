{
  flake.modules.nixvim.navigator = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib.nixvim.utils) mkRaw;
    keymaps = [
      {
        action = mkRaw ''
          function()
            require("Navigator").left()
          end
        '';
        key = "<M-h>";
        options.desc = "Move to left window";
      }
      {
        action = mkRaw ''
          function()
            require("Navigator").down()
          end
        '';
        key = "<M-j>";
        options.desc = "Move to down window";
      }
      {
        action = mkRaw ''
          function()
            require("Navigator").up()
          end
        '';
        key = "<M-k>";
        options.desc = "Move to up window";
      }
      {
        action = mkRaw ''
          function()
            require("Navigator").right()
          end
        '';
        key = "<M-l>";
        options.desc = "Move to right window";
      }
    ];
  in {
    inherit keymaps;
    extraConfigLua = ''
      require("Navigator").setup()
    '';
    extraPlugins = with pkgs.vimPlugins; [
      Navigator-nvim
    ];
  };
}
