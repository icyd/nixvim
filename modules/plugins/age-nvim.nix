{
  flake.modules.nixvim.core = {lib, ...}:
    lib.nixvim.plugins.mkNeovimPlugin rec {
      name = "age-nvim";
      package = ["local" name];
      maintainers = [];
      callSetup = false;
    };
}
