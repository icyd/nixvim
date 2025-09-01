{
  flake.modules.nixvim.auto-session = {
    lib,
    config,
    ...
  }: let
    inherit (config.utils.mkKey) mkKeyMap keymapUnlazy keymap2Lazy wKeyObj;
    keymaps = builtins.map mkKeyMap (lib.optionals config.plugins.auto-session.enable [
      {
        action = "<cmd>SessionRestore<CR>";
        key = "<leader>q.";
        options.desc = "Restore last session";
      }
      {
        action = "<cmd>Autosession search<CR>";
        key = "<leader>qs";
        options.desc = "List session";
      }
      {
        action = "<cmd>Autosession delete<CR>";
        key = "<leader>qd";
        options.desc = "Delete session";
      }
      {
        action = "<cmd>SessionSave<CR>";
        key = "<leader>qs";
        options.desc = "Save session";
      }
      {
        action = "<cmd>SessionSearch<CR>";
        key = "<leader>qS";
        options.desc = "Save search";
      }
      {
        action = "<cmd>SessionPurgeOrphaned<CR>";
        key = "<leader>qD";
        options.desc = "Purge orphaned sessions";
      }
    ]);
  in {
    keymaps = keymapUnlazy keymaps;
    plugins.auto-session = {
      enable = true;
      lazyLoad.settings.keys = keymap2Lazy keymaps;
      settings = {
        auto_save = true;
        auto_restore = false;
      };
    };
    utils.wKeyList = lib.optionals config.plugins.telescope.enable [
      (wKeyObj ["<leader>q" "" "Session"])
    ];
  };
}
