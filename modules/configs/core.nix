{config, ...}: {
  flake.modules.config.core.imports = with config.flake.modules.nixvim; [
    core
    completion
    optimizations
    utils
    {
      wrapRc = true;
      impureRtp = false;
    }
  ];
}
