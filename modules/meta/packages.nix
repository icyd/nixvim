{
  inputs,
  lib,
  ...
} @ topLevel: {
  options.nixpkgs.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
  };
  imports =
    lib.optional (inputs.pkgs-by-name-for-flake-parts ? flakeModule)
    inputs.pkgs-by-name-for-flake-parts.flakeModule;
  config.perSystem = {
    system,
    config,
    ...
  }:
    lib.optionalAttrs (inputs.pkgs-by-name-for-flake-parts ? flakeModule) {
      pkgsDirectory = ../../packages;
    }
    // {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) topLevel.config.nixpkgs.allowedUnfreePackages;
        };
        overlays =
          [
            inputs.mcp-companion.overlays.default
            inputs.sharedserver.overlays.default
            inputs.neovim-nightly-overlay.overlays.default
            inputs.rustowl-flake.overlays.default
          ]
          ++ (
            lib.optional (inputs.pkgs-by-name-for-flake-parts ? flakeModule)
            (_final: _prev: {
              local = config.packages;
            })
          );
      };
    };
}
