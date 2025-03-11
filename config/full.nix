{self, ...}: {
  imports = with self.myModules; [
    utils
    general
    ../modules/plugins/core.nix
    completion
    debugging
    git
    lsp
    neorg
    plugins
    telescope
    tests
    treesitter
    ui
  ];
}
