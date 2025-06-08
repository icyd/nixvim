{
  perSystem = {
    lib,
    config,
    pkgs,
    ...
  }: {
    devShells.default = pkgs.mkShell (
      {
        name = "Development shell";
        meta.description = "Shell environment for modifying configuration";
        packages = with pkgs; [
          nixd
          gnumake
        ];
      }
      // (lib.optionalAttrs (config ? pre-commit) {
        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      })
    );
  };
}
