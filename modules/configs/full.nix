{
  lib,
  config,
  ...
}: {
  flake.modules.config.full.imports = lib.attrValues config.flake.modules.nixvim;
}
