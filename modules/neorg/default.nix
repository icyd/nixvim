{
  lib,
  config,
  ...
}: let
  cfg = config.plugins.neorg;
in {
  autoGroups = lib.mkIf cfg.enable {
    neorg.clear = true;
  };
  autoCmd = lib.optionals cfg.enable [
    {
      command = "setlocal conceallevel=1";
      desc = "Modify conceal level for neorg files";
      event = "FileType";
      pattern = "norg";
      group = "neorg";
    }
    {
      command = "normal gg=G``zz";
      desc = "Re-indent and center on save";
      event = "BufWritePre";
      pattern = "*.norg";
      group = "neorg";
    }
  ];
  plugins = {
    neorg = {
      enable = true;
      lazyLoad.enable = false;
      lazyLoad.settings = {
        cmd = "Neorg";
        ft = "norg";
      };
      telescopeIntegration.enable = config.plugins.telescope.enable;
      settings = {
        lazy_loading = true;
        load = let
          vimwiki_dir = ''(os.getenv("VIMWIKI_HOME") or os.getenv("HOME"))'';
        in {
          "core.defaults".__empty = null;
          "core.completion" = lib.mkIf config.plugins.cmp.enable {
            config.engine = "nvim-cmp";
          };
          "core.concealer".__empty = null;
          "core.esupports.metagen" = {
            config = {
              author = "Alberto Vázquez";
              # BUG: https://github.com/nvim-neorg/neorg/issues/1579
              update_date = false;
            };
          };
          "core.summary".config.strategy = "default";
          "core.export".config.__empty = null;
          "core.export.markdown".config.__empty = null;
          "core.dirman" = {
            config = {
              default_workspace = "notes";
              workspaces = {
                notes.__raw = ''${vimwiki_dir} .. "/org"'';
                work.__raw = ''${vimwiki_dir} .. "/org/work"'';
              };
            };
          };
          "core.journal".config.journal_folder.__raw = ''${vimwiki_dir} .. "/org/journal"'';
        };
      };
    };
  };
}
