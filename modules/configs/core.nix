{config, ...}: {
  flake.modules.config.core = {
    imports = with config.flake.modules.nixvim; [
      core
      # completion
      {
        wrapRc = true;
        impureRtp = false;
      }
    ];
  };
}
