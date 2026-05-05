{
  flake.modules.nixvim.iron = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.plugins.iron;
    inherit (config.utils.mkKey) mkKeyMapIf wKeyObjMapIf;
  in {
    keymaps = mkKeyMapIf cfg.enable [
      {
        action = "<cmd>IronRepl<CR>";
        key = "<leader>ir";
        options.desc = "IronRepl open";
      }
      {
        action = "<cmd>IronReplHere<CR>";
        key = "<leader>iR";
        options.desc = "IronRepl open here";
      }
    ];
    plugins = {
      iron = {
        enable = true;
        lazyLoad.settings.cmd = ["IronRepl" "IronReplHere"];
        settings = {
          scratch_repl = true;
          highlight.italic = true;
          ignore_blank_line = true;
          keymaps = {
            send_motion = "<leader>im";
            visual_send = "<leader>iv";
            send_file = "<leader>if";
            send_line = "<leader>il";
            send_paragraph = "<leader>ip";
            send_until_cursor = "<leader>iu";
            send_mark = "<leader>is";
            mark_motion = "<leader>ic";
            mark_visual = "<leader>ic";
            remove_mark = "<leader>id";
            cr = "<leader>i<cr>";
            interrupt = "<leader>i<space>";
            exit = "<leader>iq";
            clear = "<leader>iC";
          };
          repl_definition = {
            nix.command = ["nix" "repl"];
            python = {
              command = ["${lib.getExe pkgs.python3}"];
              format.__raw = ''
                require("iron.fts.common").bracketed_paste_python
              '';
            };
            sh.command = ["bash"];
          };
        };
      };
    };
    utils.wKeyList = wKeyObjMapIf cfg.enable [
      ["<leader>i" "󱠥" "REPL (iron)"]
    ];
  };
}
