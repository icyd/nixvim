{
  pkgs,
  vimUtils,
  ...
}:
vimUtils.buildVimPlugin rec {
  pname = "blink-cmp-wezterm";
  version = "git";
  src = pkgs.fetchFromGitHub {
    owner = "junkblocker";
    repo = pname;
    rev = "main";
    hash = "sha256-8sEcwkMIRTpxscNWvaaXC62l72qLbBK0UEtPmYp4AYk=";
  };
}
