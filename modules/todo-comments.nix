{
  flake.modules.nixvim.todo-comments = {
    lib,
    config,
    ...
  }: let
    cfgTelescopeEna = config.plugins.telescope.enable;
    cfgTroubleEna = config.plugins.trouble.enable;
    TelescopeLoad = lib.optionalString cfgTelescopeEna ''require("lz.n").trigger_load("telescope")'';
    TroubleLoad = lib.optionalString cfgTroubleEna ''require("lz.n").trigger_load("trouble.nvim")'';
  in {
    plugins = {
      todo-comments = {
        enable = true;
        lazyLoad.settings = {
          before = lib.nixvim.utils.mkRaw ''
            function()
              ${TelescopeLoad}
              ${TroubleLoad}
            end
          '';
          cmd =
            [
              "TodoQuickFix"
              "TodoLocList"
            ]
            ++ lib.optionals cfgTelescopeEna ["TodoTelescope"]
            ++ lib.optionals cfgTroubleEna ["TodoTrouble"];
        };
        keymaps = {
          todoQuickFix.key = "<leader>tt";
          todoTelescope.key = lib.mkIf cfgTelescopeEna "<leader>ft";
          todoTrouble.key = lib.mkIf cfgTroubleEna "<leader>xt";
        };
      };
    };
  };
}
