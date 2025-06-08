default: check

update:
	nix flake update

lint:
	nix fmt

check: lint
	nix flake check

dev:
	nix develop

build:
	nix build .#$(target)

run:
	nix run .#$(target)
