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
    rev = "57205110493b6719fd489c147f97dcbc349790b1";
    hash = "sha256-LncfFmUytXWSBB5k/ToNmeQiwMH4v633/TkklTWjfIQ=";
  };
}
