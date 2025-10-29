{
  lib,
  inputs,
  ...
}: {
  imports = lib.optional (inputs.git-hooks ? flakeModule) inputs.git-hooks.flakeModule;

  perSystem = {lib, ...}:
    lib.optionalAttrs (inputs.git-hooks ? flakeModule) {
      pre-commit = {
        check.enable = false;
        settings.hooks = {
          actionlint.enable = true;
          deadnix.enable = true;
          luacheck = {
            enable = true;
            args = ["--globals" "vim" "--"];
          };
          statix.enable = true;
          treefmt.enable = false;
          typos.enable = true;
        };
      };
    };
}
