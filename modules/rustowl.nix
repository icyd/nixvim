{
  flake.modules.nixvim.rustowl = {
    lib,
    config,
    pkgs,
    ...
  }: let
    settings = {
      auto_enable = false;
      idle_time = 300;
      highlight_style = "underline";
      client = {
        root_dir.__raw = ''
          function()
            return vim.fs.root(0, { "Cargo.toml" })
          end
        '';
        on_attach.__raw = ''
          function(_, buffer)
            local function rustowl_notify(message, level)
              vim.notify(message, level or vim.log.levels.INFO, { title = "RustOwl" })
            end

            local function map(key, action, desc)
              vim.keymap.set("n", key, function()
                local rustowl = require("rustowl")
                rustowl[action](buffer)
                rustowl_notify("RustOwl " .. action:gsub("_", " "))
              end, { buffer = buffer, desc = desc })
            end

            map("<leader>zv", "enable", "Enable RustOwl")
            map("<leader>zV", "disable", "Disable RustOwl")

            vim.keymap.set("n", "<leader>zR", function()
              vim.cmd("Rustowl restart_client")
              rustowl_notify("RustOwl client restarted")
            end, { buffer = buffer, desc = "Restart RustOwl Client" })
          end
        '';
      };
    };
    inherit (config.utils.mkKey) mkKeyMap keymapUnlazy keymap2Lazy;
    keymaps = mkKeyMap [
      {
        action.__raw = ''
          function()
            local rustowl = require("rustowl")
            rustowl.toggle()

            vim.notify(
              "RustOwl " .. (rustowl.is_enabled() and "enabled" or "disabled"),
              vim.log.levels.INFO,
              { title = "RustOwl" }
            )
          end
        '';
        key = "<leader>lw";
        options.desc = "Toggle RustOwl";
      }
    ];
  in {
    keymaps = keymapUnlazy keymaps;
    extraPackages = with pkgs; [rustowl];
    extraPlugins = with pkgs; [rustowl-nvim];
    plugins.lz-n.plugins = [
      {
        __unkeyed-1 = "rustowl";
        enabled = true;
        keys = keymap2Lazy keymaps;
        after.__raw = ''
          function()
            require("rustowl").setup(${lib.nixvim.toLuaObject settings})
          end
        '';
      }
    ];
  };
}
