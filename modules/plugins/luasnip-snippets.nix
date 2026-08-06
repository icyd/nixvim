{
  flake.modules.nixvim.core = {lib, ...}:
    lib.nixvim.plugins.mkNeovimPlugin rec {
      name = "luasnip-snippets";
      moduleName = "luasnip_snippets.common.snip_utils";
      package = ["local" name];
      maintainers = [];
    };
}
