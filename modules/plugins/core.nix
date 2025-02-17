{
  config,
  pkgs,
  ...
}: {
  extraPlugins = with pkgs.vimPlugins; [
    unimpaired-nvim
  ];
  plugins = {
    lz-n = {
      enable = true;
      plugins = [
        {
          __unkeyed-1 = "unimpaired-nvim";
          after = ''
            function()
              require("unimpaired").setup()
            end
          '';
          event = "BufReadPre";
        }
      ];
    };
    nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;
        disable_in_macro = true;
        disable_in_visualblock = true;
      };
    };
    nvim-surround = {
      enable = true;
      lazyLoad.settings.event = "BufReadPre";
    };
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
    which-key = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      settings.spec = config.my.wKeyList;
    };
    vim-matchup = {
      enable = true;
      settings.matchparen_offscreen.method = "status";
    };
  };
}
