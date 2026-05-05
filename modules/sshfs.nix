{
  flake.modules.nixvim.sshfs = {
    lib,
    pkgs,
    ...
  }:
    lib.mkIf pkgs.stdenv.isLinux {
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
