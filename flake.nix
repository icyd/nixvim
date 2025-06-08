{
  description = "Icyd's nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixvim,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({self, ...}: {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [
        inputs.git-hooks-nix.flakeModule
        inputs.treefmt-nix.flakeModule
        ./modules
      ];

      perSystem = {
        config,
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
          output = nixvim.lib.${system}.check.mkTestDerivationFromNixvimModule attrs;
        in
          output // {meta = output.meta // {inherit description;};};
        nixvimPkg = attrs: description: let
          output = nixvim.legacyPackages.${system}.makeNixvimWithModule attrs;
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

        pre-commit = {
          check.enable = false;
          settings.hooks.treefmt.enable = true;
        };

        treefmt = {
          flakeFormatter = true;
          flakeCheck = true;
          projectRootFile = "flake.nix";
          programs = {
            deadnix.enable = true;
            jsonfmt.enable = true;
            nixfmt = {
              enable = true;
              package = pkgs.alejandra;
            };
            stylua.enable = true;
            typos.enable = true;
          };
          settings.global.excludes = [
            ".envrc"
            "Makefile"
            "README.md"
          ];
        };

        devShells.default = pkgs.mkShell {
          name = "Development shell";
          meta.description = "Shell environment for modifying configuration";
          packages = with pkgs; [
            nixd
            gnumake
          ];
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };
      };
    });
}
