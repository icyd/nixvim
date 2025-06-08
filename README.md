# Nix powered configuration for Neovim

[Neovim](https://neovim.io/) declarative configuration using [Nix](https://nixos.org/),
and distributed as flake via [Nixvim](https://github.com/nix-community/nixvim).

Provides two package:

- default: full featured Neovim distribution.
- nvimin: minimal editor for fast editing.

## Adding as Flake input in your nix configuration

```nix
{
  inputs = {
    nixvim.url = "github:icyd/nixvim";
  }
  outputs = {self, ...}@inputs: let
    system = "x86_64-linux";
  in {
    # nixos
    environments.systemPackages = [
      inputs.nixvim.packages.${system}.default
    ];
    # home-manager
    home.packages = [
      inputs.nixvim.packages.${system}.default
    ];
  }

}
```

### Testing your new configuration locally

```bash
  make build && ./result/bin/nvim
```

### Reviewing Neovim's configuration

```bash
  make build && ./result/bin/nixvim-print-init
```
