{
  flake.modules.nixvim.core = {
    lib,
    config,
    pkgs,
    ...
  }: {
    extraPackages = with pkgs; (lib.optional config.plugins.blink-cmp-git.enable glab);
    dependencies = {
      direnv = {
        inherit (config.plugins.direnv) enable;
        packageFallback = true;
      };
      gh.enable = config.plugins.blink-cmp-git.enable;
      nodejs.enable = true;
      ripgrep.enable = true;
      rust-analyzer = {
        enable = config.plugins.lsp.servers.rust_analyzer.enable || config.plugins.rustaceanvim.enable;
        packageFallback = true;
      };
      tree-sitter.enable = config.plugins.treesitter.enable;
    };
  };
}
