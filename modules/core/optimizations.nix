{
  flake.modules.nixvim.core = {
    lib,
    config,
    ...
  }: {
    performance = lib.mkIf config.optimizationEnable {
      byteCompileLua = {
        enable = true;
        nvimRuntime = true;
        configs = true;
        plugins = true;
      };
    };
  };
}
