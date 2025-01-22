{ inputs, pkgs, ... }:
{
  colorschemes.kanagawa.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      neovim-unwrapped =
        inputs.neovim-nightly-overlay.packages.${final.stdenv.hostPlatform.system}.default;
    })
  ];
  extraPackages = with pkgs; [
    ripgrep
  ];
  imports = [
    ./autocmds.nix
    ./keybindings.nix
    ./options.nix
    ./plugins/core.nix
  ];
  withPython3 = false;
  withRuby = false;
}

