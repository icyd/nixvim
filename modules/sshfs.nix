{
  flake.modules.nixvim.sshfs = {
    # lib,
    # config,
    pkgs,
    ...
  }: let
    # inherit (lib.nixvim.utils) mkRaw;
    # inherit (config.utils.mkKey) mkKeyMap keymap2Lazy;
    # keymapsTerm = let
    #   cfg = config.plugins.snacks;
    # in
    #   builtins.map mkKeyMap (lib.optionals (cfg.enable && cfg.settings.terminal.enabled) [
    #     {
    #       action = mkRaw ''
    #         function()
    #           require("snacks").terminal.toggle()
    #         end
    #       '';
    #       key = "<leader>'";
    #       options.desc = "Toggle Terminal";
    #     }
    #   ]);
    # keymaps =
    #   builtins.map mkKeyMap [
    #     {
    #       action = "<cmd>UndotreeToggle<CR>";
    #       key = "<leader>U";
    #       options.desc = "Toggle Undotree";
    #     }
    #   ]
    #   ++ keymapsTerm;
  in {
    # inherit keymaps;
    extraPackages = with pkgs; [
      sshfs
    ];
    extraPlugins = with pkgs.local; [
      sshfs-nvim
    ];
    extraConfigLua = ''
      require("sshfs").setup()
    '';
    plugins = {
      # lz-n.plugins = [
      #   {
      #     __unkeyed-1 = "playground";
      #     cmd = "TSPlaygroundToggle";
      #   }
      #   {
      #     __unkeyed-1 = "vim-gnupg";
      #     ft = [
      #       "gpg"
      #       "asc"
      #       "pgp"
      #     ];
      #   }
      # ];
    };
  };
}
