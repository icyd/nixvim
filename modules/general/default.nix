{
  inputs,
  pkgs,
  ...
}: {
  colorschemes.kanagawa.enable = true;
  nixpkgs.overlays = [
    (final: _prev: {
      neovim-unwrapped =
        inputs.neovim-nightly-overlay.packages.${final.stdenv.hostPlatform.system}.default;
    })
  ];
  extraPackages = with pkgs; [
    ripgrep
  ];
  withPython3 = false;
  withRuby = false;
  performance = {
    byteCompileLua = {
      enable = true;
      nvimRuntime = true;
      configs = true;
      plugins = true;
    };
  };
  imports = with builtins;
    map (fn: ./${fn})
    (filter
      (fn: (
        fn != "default.nix"
      ))
      (attrNames (readDir ./.)));
}
