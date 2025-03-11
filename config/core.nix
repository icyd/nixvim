{self, ...}: {
  imports =
    [
      ../modules/ui/core.nix
      ../modules/plugins/core.nix
    ]
    ++ (with self.myModules; [
      utils
      general
      completion
    ]);
}
