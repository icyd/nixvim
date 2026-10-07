{
  flake.modules.nixvim.core = {pkgs, ...}: {
    # colorschemes.catppuccin.enable = true;
    # colorschemes.kanagawa.enable = true;
    # colorschemes.monokai-pro.enable = true;
    colorschemes.tokyonight.enable = true;
    extraPackages = with pkgs; [
      ripgrep
    ];
    withNodeJs = false;
    withPerl = false;
    withPython3 = false;
    withRuby = false;
  };
}
