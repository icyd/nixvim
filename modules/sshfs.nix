{
  flake.modules.nixvim.sshfs = {pkgs, ...}: let
  in {
    extraPackages = with pkgs; [
      sshfs
    ];
    extraPlugins = with pkgs.local; [
      sshfs-nvim
    ];
    extraConfigLua = ''
      require("sshfs").setup()
    '';
  };
}
