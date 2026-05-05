{
  flake.modules.nixvim.openscad = {config, ...}: let
    inherit (config.utils.mkKey) mkKeyMap wKeyObjMapIf;
    keymaps = mkKeyMap [
      {
        action.__raw = ''
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
        action.__raw = ''
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
        action.__raw = ''
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
        action.__raw = ''
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
        action.__raw = ''
          function()
            require("openscad").topToggle()
          end
        '';
        # typos:ignore-next-line
        key = "<leader>ot";
        options = {
          desc = "Toggle htop";
        };
      }
    ];
  in {
    inherit keymaps;
    extraConfigLua = ''
      vim.g.openscad_pdf_command = "zathura";
      vim.g.openscad_fuzzy_finder = "snacks";
    '';
    plugins.openscad = {
      enable = false;
      lazyLoad.settings.ft = "openscad";
      settings = {
        auto_open = false;
        fuzzy_finder = null;
        default_mappings = false;
        load_snippets = true;
      };
    };
    utils.wKeyList = wKeyObjMapIf config.plugins.openscad.enable [
      ["<leader>o" "" "Openscad"]
    ];
  };
}
