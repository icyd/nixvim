{
  flake.modules.nixvim.openscad = {
    lib,
    config,
    pkgs,
    ...
  }: let
    inherit (lib.nixvim.utils) mkRaw;
    inherit (config.utils.mkKey) mkKeyMap wKeyObj;
    keymaps = builtins.map mkKeyMap [
      {
        action = mkRaw ''
          function()
            require("openscad").toggle()
          end
        '';
        key = "<leader>oc";
        options = {
          desc = "Toggle cheatsheet";
        };
      }
      {
        action = mkRaw ''
          function()
            require("openscad").help()
          end
        '';
        key = "<leader>oh";
        options = {
          desc = "Trigger help";
        };
      }
      {
        action = mkRaw ''
          function()
            require("openscad").manual()
          end
        '';
        key = "<leader>om";
        options = {
          desc = "Trigger manual";
        };
      }
      {
        action = mkRaw ''
          function()
            require("openscad").exec_openscad()
          end
        '';
        key = "<leader>ox";
        options = {
          desc = "Exec Openscad";
        };
      }
      {
        action = mkRaw ''
          function()
            require("openscad").topToggle()
          end
        '';
        key = "<leader>ot";
        options = {
          desc = "Toggle htop";
        };
      }
    ];
  in {
    inherit keymaps;
    extraPackages = with pkgs; [
      htop
      zathura
    ];
    extraConfigLua = ''
      vim.g.openscad_pdf_command = "zathura";
      vim.g.openscad_fuzzy_finder = "snacks";
    '';
    plugins.openscad = {
      enable = true;
      lazyLoad.settings.ft = "openscad";
      settings = {
        auto_open = true;
        default_mappings = false;
        load_snippets = true;
      };
    };
    utils.wKeyList = lib.optionals config.plugins.openscad.enable [
      (wKeyObj ["<leader>o" "" "Openscad"])
    ];
  };
}
