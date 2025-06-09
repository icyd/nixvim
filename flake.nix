{
  description = "Icyd's nixvim configuration";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://icyd.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "icyd.cachix.org-1:gndst9U1QOpne+Ib7Dx5W70MNHJy6bezdPhQHIJhy8I="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    allow-import-from-derivation = false;
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({self, ...}: {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [
        inputs.flake-parts.flakeModules.partitions
        ./modules
      ];

      partitions = {
        dev = {
          module = ./dev;
          extraInputsFlake = ./dev;
        };
      };

      partitionedAttrs = {
        checks = "dev";
        devShells = "dev";
        formatter = "dev";
      };

      perSystem = {
        pkgs,
        system,
        ...
      }: let
        nixvimModule = imports: {
          inherit pkgs;
          extraSpecialArgs = {
            inherit self inputs;
          };
          module = {inherit imports;};
        };
        nixvimCheck = attrs: description: let
          output = inputs.nixvim.lib.${system}.check.mkTestDerivationFromNixvimModule attrs;
        in
          output // {meta = output.meta // {inherit description;};};
        nixvimPkg = attrs: description: let
          output = inputs.nixvim.legacyPackages.${system}.makeNixvimWithModule attrs;
        in
          output // {meta = output.meta // {inherit description;};};
        fullAttrs = [./config/full.nix];
        coreAttrs = [
          ./config/core.nix
          {
            wrapRc = true;
            impureRtp = false;
          }
        ];
      in {
        checks = {
          nvimin = nixvimCheck (nixvimModule coreAttrs) "Check if core builds";
          default = nixvimCheck (nixvimModule fullAttrs) "Check if full builds";
        };

        packages = {
          nvimin = nixvimPkg (nixvimModule coreAttrs) "Minimal build for fast editing";
          default = nixvimPkg (nixvimModule fullAttrs) "Full utility set";
        };
      };
    });
}
