{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin {
  pname = "nvim-rooter";
  version = "latest";
  src = fetchFromGitHub {
    owner = "icyd";
    repo = "nvim-rooter.lua";
    rev = "main";
    hash = "sha256-LncfFmUytXWSBB5k/ToNmeQiwMH4v633/TkklTWjfIQ=";
  };
}
