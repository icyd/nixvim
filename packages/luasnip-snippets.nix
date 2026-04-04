{pkgs, ...}:
pkgs.vimUtils.buildVimPlugin {
  pname = "luasnip-snippets";
  version = "latest";
  src = pkgs.fetchFromGitHub {
    owner = "mireq";
    repo = "luasnip-snippets";
    rev = "main";
    hash = "sha256-oG5aWi1zVUhl9YG6WbjtocZLBVO/yKt2Dui8HYTCrQs=";
  };
  meta.homepage = "https://github.com/mireq/luasnip-snippets.git";
  buildInputs = with pkgs; [
    luajitPackages.luasnip
  ];
  nvimSkipModules = [
    "luasnip_snippets.all"
  ];
}
