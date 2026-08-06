{
  flake.modules.nixvim.core = {lib, ...}:
    lib.nixvim.plugins.mkVimPlugin {
      name = "vim-gnupg";
      maintainers = [];
      globalPrefix = "GPG";
    };
}
