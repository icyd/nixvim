{
  flake.modules.nixvim.optimizations = {
    performance = {
      byteCompileLua = {
        enable = true;
        nvimRuntime = true;
        configs = true;
        plugins = true;
      };
    };
  };
}
