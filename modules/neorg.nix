{
  flake.modules.nixvim.neorg = {
    lib,
    config,
    pkgs,
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
    extraPlugins = with pkgs.vimPlugins; [
      {
        plugin = neorg-interim-ls;
        optional = true;
      }
    ];
    plugins = {
      neorg = {
        enable = true;
        lazyLoad.settings = {
          cmd = "Neorg";
          ft = "norg";
          before.__raw = ''
            function()
              vim.cmd("packadd neorg-interim-ls")
            end
          '';
        };
        luaConfig.pre = ''
          norg_dir = (os.getenv("ORGMODE_DIR") or os.getenv("HOME")) .. "/org"
        '';
        settings = {
          lazy_loading = true;
          load = with lib.nixvim.utils; {
            "core.defaults" = emptyTable;
            "core.completion".config.engine = {
              module_name = "external.lsp-completion";
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
                  notes.__raw = ''norg_dir'';
                  work.__raw = ''norg_dir .. "/work"'';
                };
              };
            };
            "core.journal".config.journal_folder.__raw = ''norg_dir .. "/journal"'';
            "external.lsp-completion".config = {
              completion_provider = {
                enable = true;
                documentation = true;
              };
            };
          };
        };
      };
    };
  };
}
