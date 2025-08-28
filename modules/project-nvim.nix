{
  flake.modules.nixvim.project-nvim = {
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap;
    inherit (lib.nixvim.utils) mkRaw;
    # keymaps = builtins.map mkKeyMap (lib.optionals (config.plugins.telescope.enable && config.plugins.project-nvim.enable) [
    #   {
    #     action = "<cmd>Telescope projects<CR>";
    #     key = "<leader>fp";
    #     options.desc = "Find projects";
    #   }
    # ]);
    keymaps = builtins.map mkKeyMap (lib.optionals config.plugins.telescope.enable [
      {
        action = "<cmd>Telescope projects<CR>";
        key = "<leader>fp";
        options.desc = "Find projects";
      }
    ]);
  in {
    inherit keymaps;
    # NOTE: https://github.com/nix-community/nixvim/issues/3654
    extraPlugins = with pkgs; [
      (vimUtils.buildVimPlugin {
        name = "project";
        src = pkgs.fetchFromGitHub {
          owner = "DrKJeff16";
          repo = "project.nvim";
          rev = "1438dc7997ba35f4acfcfc41b907fa5227049d6e";
          sha256 = "02vdl8v5wkhh2cxwn3j01v8icwxjhlwd1q2g3mk3gggp9cqkfikj";
        };
      })
    ];
    plugins.lz-n.plugins = [
      {
        __unkeyed-1 = "project";
        event = "DeferredUIEnter";
        before = mkRaw ''
          require("lz.n").trigger_load("telescope")
        '';
        after = mkRaw ''
          require("project").setup({
            detection_methods = {"pattern", "lsp"},
            scope_chdir = "win",
            show_hidden = true,
          })
        '';
      }
    ];
    plugins.project-nvim = {
      enable = false;
      enableTelescope = config.plugins.telescope.enable;
      lazyLoad.settings = {
        event = "DeferredUIEnter";
        before = mkRaw ''
          require("lz.n").trigger_load("telescope")
        '';
      };
      settings = {
        detection_methods = ["pattern" "lsp"];
        scope_chdir = "win";
        show_hidden = true;
      };
    };
  };
}
