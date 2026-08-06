{
  pkgs,
  vimUtils,
  ...
}:
vimUtils.buildVimPlugin {
  pname = "age-nvim";
  version = "0.1.0";
  src = pkgs.fetchFromGitHub {
    owner = "KingMichaelPark";
    repo = "/age.nvim";
    rev = "b09aa597f8d421fa06825f726036a4fb0205437e";
    hash = "sha256-4dcuw55akTKXGAU/+ydY2Sv9b6x8qdjfOsYw67A2JVY=";
  };
}
