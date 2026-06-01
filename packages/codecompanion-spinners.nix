{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin rec {
  pname = "codecompanion-spinners";
  version = "git";
  src = fetchFromGitHub {
    owner = "lalitmee";
    repo = "${pname}.nvim";
    rev = "86926cbf7554d69d40d2a5c3cf576063814a42d5";
    hash = "sha256-L+vG4wj2O1VaiHhhjBAi26nglW0WnPSTk8FihkK8cn0=";
  };
}
