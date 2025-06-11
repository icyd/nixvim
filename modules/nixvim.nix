{
  config,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    inherit (config.flake.modules.config) core full;
    inherit (inputs.nixvim.lib.${system}.check) mkTestDerivationFromNixvimModule;
    inherit (inputs.nixvim.legacyPackages.${system}) makeNixvimWithModule;
    nixvimModule = fn: module: description: let
      output = fn {inherit pkgs module;};
    in
      output // {meta = output.meta // {inherit description;};};
    nixvimCheck = nixvimModule mkTestDerivationFromNixvimModule;
    nixvimPkg = nixvimModule makeNixvimWithModule;
  in {
    checks = {
      nvimin = nixvimCheck core "Check if core builds";
      default = nixvimCheck full "Check if full builds";
    };

    packages = {
      nvimin = nixvimPkg core "Minimal build for fast editing";
      default = nixvimPkg full "Full utility set";
    };
  };
}
