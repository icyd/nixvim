{pkgs, ...}:
pkgs.vimUtils.buildVimPlugin {
  pname = "luasnip-snippets";
  version = "latest";
  src = pkgs.fetchFromGitHub {
    owner = "mireq";
    repo = "luasnip-snippets";
    rev = "44b20b98c7cc8fc595407993f0bdc96def4215f7";
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
  ];
}
