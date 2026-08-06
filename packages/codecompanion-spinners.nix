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
    rev = "f613a543ca8c7ba1686830c6bb1a10d15a2e1942";
    hash = "sha256-SOjECXjHu+JjGIAFDFroOyHsBqYGK3+xZ8f7w7yjFvQ=";
  };
}
