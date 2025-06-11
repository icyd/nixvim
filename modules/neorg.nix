{
  flake.modules.nixvim.neorg = {
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
        luaConfig.pre = ''
          norg_dir = (os.getenv("ORGMODE_DIR") or os.getenv("HOME")) .. "/org"
        '';
        telescopeIntegration.enable = config.plugins.telescope.enable;
        settings = {
          lazy_loading = true;
          load = with lib.nixvim.utils; {
            "core.defaults" = emptyTable;
            "core.completion" = lib.mkIf config.plugins.cmp.enable {
              config.engine = "nvim-cmp";
            };
            "core.concealer" = emptyTable;
            "core.esupports.metagen" = {
              config = {
                author = "Alberto Vázquez";
                # BUG: https://github.com/nvim-neorg/neorg/issues/1579
                update_date = false;
              };
            };
            "core.summary".config.strategy = "default";
            "core.export".config = emptyTable;
            "core.export.markdown".config = emptyTable;
            "core.dirman" = {
              config = {
                default_workspace = "notes";
                workspaces = {
                  notes = mkRaw ''norg_dir'';
                  work = mkRaw ''norg_dir .. "/work"'';
                };
              };
            };
            "core.journal".config.journal_folder = mkRaw ''norg_dir .. "/journal"'';
          };
        };
      };
    };
  };
}
