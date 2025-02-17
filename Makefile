update:
	nix flake update

lint:
	nix fmt

check: lint
	nix flake check

dev:
	nix develop

run:
	nix run .#$(target)
