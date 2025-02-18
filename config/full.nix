{self, ...}: {
  imports = with self.myModules; [
    utils
    general
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
