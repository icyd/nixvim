{
  vimUtils,
  fetchFromGitHub,
  ...
}:
vimUtils.buildVimPlugin rec {
  pname = "codecompanion-ui";
  version = "git";
  src = fetchFromGitHub {
    owner = "mrjones2014";
    repo = "${pname}.nvim";
    rev = "b842496a23d0b0c79907ba89644f70f013ac40f8";
    hash = "sha256-3LISzlkFVVRx8yy3hK8oP+BsAnM5kQj0sMc+4MR+YCM=";
  };
}
