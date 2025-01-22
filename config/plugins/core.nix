{
  pkgs,
  ...
}:
{
  extraPlugins = with pkgs.vimPlugins; [
    unimpaired-nvim
  ];
  plugins = {
    lualine.enable = true;
    nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;
        disable_in_macro = true;
        disable_in_visualblock = true;
      };
    };
    nvim-surround.enable = true;
    rainbow-delimiters.enable = true;
    treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        nu
      ];
      settings = {
        highlight.enable = true;
      };
    };
    vim-matchup = {
      enable = true;
      settings.matchparen_offscreen.method = "status";
    };
  };
}
