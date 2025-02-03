{
  plugins = {
    neorg = {
      enable = true;
      luaConfig.pre = ''
        local vimwiki_dir = os.getenv("VIMWIKI_HOME")
      '';
      telescopeIntegration.enable = true;
      settings = {
        load = {
          "core.defaults" = {
            __empty = null;
          };
          "core.completion" = {
            config.engine = "nvim-cmp";
          };
          "core.esupports.metagen" = {
            config = {
              author = "Alberto Vázquez";
              # BUG: https://github.com/nvim-neorg/neorg/issues/1579
              update_date = false;
            };
          };
          "core.summary" = {
            config.strategy = "default";
          };
          "core.export".config = {
            __empty = null;
          };
          "core.export.markdown".config = {
            __empty = null;
          };
          "core.dirman" = {
            config = {
              default_workspace = "notes";
              workspaces = {
                notes.__raw = ''vimwiki_dir .. "/org"'';
                work.__raw = ''vimwiki_dir .. "/org/work"'';
              };
            };
          };
          "core.journal" = {
            config.journal_folder.__raw = ''vimwiki_dir .. "/org/journal"'';
          };
        };
      };
    };
  };
}
