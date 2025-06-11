{
  lib,
  inputs,
  ...
}: {
  imports =
    lib.optional (inputs.pkgs-by-name-for-flake-parts ? flakeModule)
    inputs.pkgs-by-name-for-flake-parts.flakeModule;
  perSystem = {
    system,
    config,
    ...
  }:
    lib.optionalAttrs (inputs.pkgs-by-name-for-flake-parts ? flakeModule) {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (final: _prev: {
            local = config.packages;
            neovim-unwrapped =
              inputs.neovim-nightly-overlay.packages.${final.stdenv.hostPlatform.system}.default;
          })
        ];
      };
      pkgsDirectory = ../../packages;
    };
}
