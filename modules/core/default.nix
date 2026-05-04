{
  flake.modules.nixvim.core = {pkgs, ...}: {
    colorschemes.kanagawa.enable = true;
    extraPackages = with pkgs; [
      ripgrep
    ];
    withPython3 = false;
    withRuby = false;
  };
}
