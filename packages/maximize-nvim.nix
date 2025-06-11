{
  pkgs,
  vimUtils,
  ...
}:
vimUtils.buildVimPlugin {
  name = "maximize-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "declancm";
    repo = "/maximize.nvim";
    rev = "d688b66344b03ee6e5a32a0a40af85d174490af8";
    hash = "sha256-rwnvX+Sul+bwESZtpqbvaDJuk49SV9tLUnvgiAH4VMs=";
  };
}
