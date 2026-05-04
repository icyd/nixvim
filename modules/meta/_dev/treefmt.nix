{
  lib,
  inputs,
  ...
}: {
  imports = lib.optional (inputs.treefmt-nix ? flakeModule) inputs.treefmt-nix.flakeModule;

  perSystem = {
    lib,
    pkgs,
    ...
  }:
    lib.optionalAttrs (inputs.treefmt-nix ? flakeModule) {
      treefmt = {
        # BUG: https://github.com/numtide/treefmt-nix/issues/156
        flakeCheck = false;
        flakeFormatter = true;
        projectRootFile = "flake.nix";
        programs = {
          actionlint.enable = true;
          deadnix.enable = true;
          jsonfmt.enable = true;
          nixfmt = {
            enable = true;
            package = pkgs.alejandra;
          };
          statix.enable = true;
          stylua.enable = true;
          typos = let
            configFile = pkgs.writeText "typos.toml" ''
              [default]
              extend-ignore-re = [
                  # Ignore the line after `# typos:ignore-next-line`:
                  "(#|--|//)\\s*typos:ignore-next-line\\n.*",
                  # Ignore blocks between `# typos:disabled` and `# typos:enabled`
                  "(?s)(#|--|//)\\s*typos:disabled.*?\\n\\s*(#|--|//)\\s*typos:enabled",
              ]
            '';
          in {
            enable = true;
            configFile = "${configFile}";
          };
          yamlfmt = {
            enable = true;
            settings.formatter = {
              include_document_start = true;
            };
          };
        };
        settings.global.excludes = [
          ".envrc"
          "Makefile"
          "README.md"
        ];
      };
    };
}
