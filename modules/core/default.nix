{
  flake.modules.nixvim.core = {pkgs, ...}: {
    # colorschemes.catppuccin.enable = true;
    # colorschemes.kanagawa.enable = true;
    # colorschemes.monokai-pro.enable = true;
    colorschemes.tokyonight.enable = true;
    extraPackages = with pkgs; [
      ripgrep
    ];
    withPython3 = false;
    withRuby = false;
  };
}
