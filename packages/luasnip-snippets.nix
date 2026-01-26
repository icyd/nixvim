{pkgs, ...}:
pkgs.vimUtils.buildVimPlugin {
  pname = "luasnip-snippets";
  version = "latest";
  src = pkgs.fetchFromGitHub {
    owner = "mireq";
    repo = "luasnip-snippets";
    rev = "9bd2d21915eb9b27720fc92a9a8def49023cfa37";
    hash = "sha256-z4JCfrt5qZ9FBjkRtORmv2y8wCF0RIJQPpMGWdUHifA=";
  };
  meta.homepage = "https://github.com/mireq/luasnip-snippets.git";
  buildInputs = with pkgs; [
    luajitPackages.luasnip
    vimPlugins.nvim-treesitter
    python313Packages.pynvim
  ];
  nvimSkipModules = [
    "luasnip_snippets.all"
    "luasnip_snippets.python_extra"
  ];
}
