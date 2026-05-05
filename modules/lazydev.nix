{
  flake.modules.nixvim.lazydev = {
    plugins = {
      lazydev = {
        enable = true;
        lazyLoad.settings = {
          ft = ["lua"];
        };
        settings.library = [
          "luasnip"
          # {
          #   path = "luasnip";
          #   mods = ["luasnip"];
          # }
        ];
      };
      blink-cmp.settings.sources.providers.lazydev = {
        name = "LazyDev";
        module = "lazydev.integrations.blink";
        score_offset = 100;
      };
    };
  };
}
