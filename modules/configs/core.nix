{config, ...}: {
  flake.modules.config.core = {
    plugins.snacks.settings.quickfile.enabled = true;
    imports = with config.flake.modules.nixvim; [
      core
      completion
      optimizations
      utils
      {
        wrapRc = true;
        impureRtp = false;
      }
    ];
  };
}
