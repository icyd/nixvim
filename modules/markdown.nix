{
  flake.modules.nixvim.markdown = {
    lib,
    pkgs,
    ...
  }: let
    inherit (lib.nixvim.utils) mkRaw;
  in {
    extraPlugins = with pkgs.local; [
      auto-pandoc-nvim
    ];
    plugins = {
      bullets = {
        enable = true;
        settings = {
          checkbox_markers = "✗○◐●✓";
          custom_mappings = [
            ["imap" "<CR>" "<Plug>(bullets-newline)"]
            ["nmap" "o" "<Plug>(bullets-newline)"]
            ["inoremap" "<C-CR>" "<CR>"]
            ["nmap" "gN" "<Plug>(bullets-renumber)"]
            ["vmap" "gN" "<Plug>(bullets-renumber)"]
            ["nmap" "<leader>xk" "<Plug>(bullets-toggle-checkbox)"]
            ["imap" "<C-t>" "<Plug>(bullets-demote)"]
            ["nmap" ">>" "<Plug>(bullets-demote)"]
            ["vmap" ">" "<Plug>(bullets-demote)"]
            ["imap" "<C-d>" "<Plug>(bullets-promote)"]
            ["nmap" "<<" "<Plug>(bullets-promote)"]
            ["vmap" "<" "<Plug>(bullets-promote)"]
          ];
          enable_in_empty_buffers = 0;
          pad_right = 0;
          set_mappings = 0;
        };
      };
      image = {
        enable = true;
        lazyLoad.settings.ft = [
          "markdown"
          "norg"
        ];
        settings = {
          backend = "kitty";
          editor_only_render_when_focused = true;
        };
      };
      markdown-preview = {
        enable = true;
        settings.auto_close = 0;
      };
      render-markdown = {
        enable = true;
        lazyLoad.settings.ft = "markdown";
        settings = {
          heading.sign = false;
        };
      };
      vimwiki = {
        enable = true;
        settings = {
          global_ext = 0;
          filetypes = ["markdown"];
          map_prefix = "<leader>W";
          list = [
            {
              path = mkRaw ''(os.getenv("VIMWIKI_HOME") or os.getenv("HOME")) .. "/vimwiki"'';
              syntax = "markdown";
              ext = ".md";
            }
          ];
        };
      };
    };
    userCommands = {
      AutoPandoc = {
        command = mkRaw ''
          function()
            require("auto-pandoc").run_pandoc()
          end
        '';
        desc = "Run auto Pandoc";
      };
    };
  };
}
