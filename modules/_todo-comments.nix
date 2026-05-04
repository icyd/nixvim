{
  flake.modules.nixvim.todo-comments = {
    lib,
    config,
    ...
  }: let
    cfgTroubleEna = config.plugins.trouble.enable;
    TroubleLoad = lib.optionalString cfgTroubleEna ''require("lz.n").trigger_load("trouble.nvim")'';
  in {
    plugins = {
      todo-comments = {
        enable = true;
        lazyLoad.settings = {
          before = lib.nixvim.utils.mkRaw ''
            function()
              ${TroubleLoad}
            end
          '';
          cmd =
            [
              "TodoQuickFix"
              "TodoLocList"
            ]
            ++ lib.optionals cfgTroubleEna ["TodoTrouble"];
        };
        keymaps = {
          todoQuickFix.key = "<leader>tt";
          todoTrouble.key = lib.mkIf cfgTroubleEna "<leader>xt";
        };
      };
    };
  };
}
