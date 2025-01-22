{
  description = "Icyd's nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { pkgs, system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = imports: {
            inherit pkgs;
            extraSpecialArgs = {
              inherit inputs;
            };
            module = { inherit imports; };
          };
          nvimMod = nixvimModule [ ./config ];
          nviminMod = nixvimModule [ 
              ./config/core.nix 
              {
                wrapRc = true;
                impureRtp = false;
              }
          ];
          nvim = nixvim'.makeNixvimWithModule nvimMod;
          nvimin = nixvim'.makeNixvimWithModule nviminMod;
        in
        {
          checks = {
            default = nixvimLib.check.mkTestDerivationFromNixvimModule nvimMod;
            nvimin = nixvimLib.check.mkTestDerivationFromNixvimModule nviminMod;
          };

          packages = {
            default = nvim;
            inherit nvimin;
          };

          devShells.default = pkgs.mkShell {
            buildInputs = [ nvim nvimin ];
          };
        };
    };
}
