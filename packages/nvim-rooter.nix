{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin {
  pname = "nvim-rooter";
  version = "latest";
  src = fetchFromGitHub {
    owner = "notjedi";
    repo = "nvim-rooter.lua";
    rev = "7689d05e8ab95acb4b24785253d913c0aae18be9";
    hash = "sha256-5I0un0QVQsfQwSF+sLgtkDa7CoZc/FIr5sIbFKcI544=";
  };
}
