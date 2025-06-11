{
  pkgs,
  vimUtils,
  ...
}:
vimUtils.buildVimPlugin {
  name = "age-secret-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "histrio";
    repo = "/age-secret.nvim";
    rev = "9be5fbdac534422dc7d03eccb9d5af96f242e16f";
    hash = "sha256-3RMSaUfZyMq9aNwBrdVIP4Mh80HwIcO7I+YhFOw+NU8=";
  };
}
