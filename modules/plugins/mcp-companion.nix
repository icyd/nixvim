{
  flake.modules.nixvim.core = {lib, ...}:
    lib.nixvim.plugins.mkNeovimPlugin {
      name = "mcp-companion";
      moduleName = "mcp_companion";
      package = ["mcp-companion-nvim"];
      maintainers = [];
    };
}
