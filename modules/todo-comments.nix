{
  flake.modules.nixvim.todo-comments = {
    lib,
    config,
    ...
  }: {
    plugins = {
      todo-comments = {
        enable = true;
        lazyLoad.settings = {
          before.__raw = lib.mkIf config.plugins.trouble.enable ''
            function()
              require("lz.n").trigger_load("trouble.nvim")
            end
          '';
          cmd =
            [
              "TodoQuickFix"
              "TodoLocList"
            ]
            ++ lib.optional config.plugins.trouble.enable "TodoTrouble";
        };
        keymaps = {
          todoQuickFix.key = "<leader>tt";
          todoTrouble.key = lib.mkIf config.plugins.trouble.enable "<leader>xt";
        };
      };
    };
  };
}
