{config, ...}: let
  inherit (config.my.mkKey) mkKeyMapWithOpts keymap2mkKeyMap wKeyObj;
in {
  globals = {
    mapleader = " ";
    maplocalleader = "\\";
  };
  keymaps =
    (keymap2mkKeyMap
      [
        {
          action = "<Nop>";
          key = "<Up>";
          mode = [
            "n"
            "i"
            "v"
          ];
          options.desc = "Disable up arrow key";
        }
        {
          action = "<Nop>";
          key = "<Down>";
          mode = [
            "n"
            "i"
            "v"
          ];
          options.desc = "Disable down arrow key";
        }
        {
          action = "<Nop>";
          key = "<Left>";
          mode = [
            "n"
            "i"
            "v"
          ];
          options.desc = "Disable left arrow key";
        }
        {
          action = "<Nop>";
          key = "<Right>";
          mode = [
            "n"
            "i"
            "v"
          ];
          options.desc = "Disable right arrow key";
        }
        {
          action = "<Nop>";
          key = "Q";
          mode = [
            "n"
            "o"
            "v"
          ];
          options.desc = "Disable Q";
        }
        {
          action = "<cmd>nohlsearch<CR>";
          key = "<leader><Space>";
          mode = "n";
          options.desc = "Remove search highlight";
        }
        {
          action = "g^";
          key = "^";
          mode = "n";
          options.desc = "Linewrap go to init";
        }
        {
          action = "g$";
          key = "$";
          mode = "n";
          options.desc = "Linewrap go to end";
        }
        {
          action = "gj";
          key = "j";
          mode = "n";
          options.desc = "Linewrap down";
        }
        {
          action = "gk";
          key = "k";
          mode = "n";
          options.desc = "Linewrap up";
        }
        {
          action = "y$";
          key = "Y";
          mode = "n";
          options.desc = "Yank whole line";
        }
        {
          action = ''"_dP'';
          key = "<localleader>P";
          mode = "v";
          options.desc = "Delete and paste";
        }
        {
          action = ''"_ddP'';
          key = "<localleader>P";
          mode = "n";
          options.desc = "Delete and paste";
        }
        {
          action = "nzzzv";
          key = "n";
          mode = "n";
          options.desc = "Center on next match";
        }
        {
          action = "Nzzzv";
          key = "N";
          mode = "n";
          options.desc = "Center on prev match";
        }
        {
          action = "mzJ`z";
          key = "J";
          mode = "n";
          options.desc = "Center when wrapping lines";
        }
        {
          action = "<cmd>split<CR>";
          key = "<leader>-";
          mode = "n";
          options.desc = "Split horizontal";
        }
        {
          action = "<cmd>vsplit<CR>";
          key = "<leader>\\";
          mode = "n";
          options.desc = "Split vertical";
        }
        # {
        #   action = "<C-a>";
        #   key = "<M-a>";
        #   mode = "n";
        #   options.desc = "Increment number";
        # }
        # {
        #   action = "<C-x>";
        #   key = "<M-x>";
        #   mode = "n";
        #   options.desc = "Decrement number";
        # }
        {
          action = "<ESC>";
          key = "jk";
          mode = "i";
          options.desc = "Escape";
        }
        {
          action = "<C-w>h";
          key = "<M-h>";
          mode = "n";
          options.desc = "Move to left window";
        }
        {
          action = "<C-w>j";
          key = "<M-j>";
          mode = "n";
          options.desc = "Move to down window";
        }
        {
          action = "<C-w>k";
          key = "<M-k>";
          mode = "n";
          options.desc = "Move to up window";
        }
        {
          action = "<C-w>l";
          key = "<M-l>";
          mode = "n";
          options.desc = "Move to right window";
        }
        {
          action = "<cmd>move '<-2<CR>gv=gv";
          key = "<C-k>";
          mode = "v";
          options.desc = "Move selected up";
        }
        {
          action = "<cmd>move '>+1<CR>gv=gv";
          key = "<C-j>";
          mode = "v";
          options.desc = "Move selected down";
        }
        {
          action = "<cmd>move .-2<CR>==";
          key = "<C-k>";
          mode = "n";
          options.desc = "Move line up";
        }
        {
          action = "<cmd>move .+1<CR>==";
          key = "<C-j>";
          mode = "n";
          options.desc = "Move line down";
        }
        {
          action = "<ESC><cmd>move .-2<CR>==";
          key = "<C-k>";
          mode = "i";
          options.desc = "Move line up";
        }
        {
          action = "<ESC><cmd>move .+1<CR>==";
          key = "<C-j>";
          mode = "i";
          options.desc = "Move line down";
        }
        {
          action = "<cmd>terminal<CR>";
          key = "<leader>'";
          mode = "n";
          options.desc = "Open terminal";
        }
        {
          action = "<C-\\><C-N>";
          key = "<ESC>";
          mode = "t";
          options.desc = "Escape terminal with ESC";
        }
        {
          action = "<C-\\><C-N><C-w>h";
          key = "<M-h>";
          mode = "t";
          options.desc = "Move to left window from terminal";
        }
        {
          action = "<C-\\><C-N><C-w>j";
          key = "<M-j>";
          mode = "t";
          options.desc = "Move to down window from terminal";
        }
        {
          action = "<C-\\><C-N><C-w>k";
          key = "<M-k>";
          mode = "t";
          options.desc = "Move to up window from terminal";
        }
        {
          action = "<C-\\><C-N><C-w>l";
          key = "<M-l>";
          mode = "t";
          options.desc = "Move to right window from terminal";
        }
        {
          action = "<cmd>tabnew<CR>";
          key = "<leader>ac";
          mode = "n";
          options.desc = "Create new tab";
        }
        {
          action = "<cmd>tabfirst<CR>";
          key = "<leader>a^";
          mode = "n";
          options.desc = "Go to first tab";
        }
        {
          action = "<cmd>tabnext<CR>";
          key = "<leader>an";
          mode = "n";
          options.desc = "Go to next tab";
        }
        {
          action = "<cmd>tabprev<CR>";
          key = "<leader>ap";
          mode = "n";
          options.desc = "Go to prev tab";
        }
        {
          action = "<cmd>tablast<CR>";
          key = "<leader>a$";
          mode = "n";
          options.desc = "Go to last tab";
        }
        {
          action = "<cmd>tabedit<CR>";
          key = "<leader>ae";
          mode = "n";
          options.desc = "Edit in new tab";
        }
        {
          action = "<cmd>tabm<Space>";
          key = "<leader>am";
          mode = "n";
          options.desc = "Tab move";
        }
        {
          action = "<cmd>tabclose<CR>";
          key = "<leader>ax";
          mode = "n";
          options.desc = "Close tab";
        }
        {
          action = "<cmd>tabnew<CR>";
          key = "<leader>ac";
          mode = "n";
          options.desc = "Create new tab";
        }
        {
          action = "<cmd>make<CR>";
          key = "<leader>X";
          mode = "n";
          options.desc = "Run Make";
        }
        {
          action = "<cmd>make<CR>";
          key = "<leader>S";
          mode = "n";
          options.desc = "Save session";
        }
        {
          action = "w !sudo tee % >/dev/null";
          key = "w!!";
          mode = "c";
          options.desc = "Save buffer with sudo";
        }
        {
          action = "<cmd>!mkdir -p %:p:h<CR>";
          key = "<leader>md";
          mode = "n";
          options.desc = "Create new dir";
        }
        {
          action = ''<cmd>lcd %:h<CR><cmd>echo "Changed directory to: "expand("%:p:h")<CR>'';
          key = "<leader>cd";
          mode = "n";
          options.desc = "Changed directory to current file's parent";
        }
        {
          action = ''<cmd>edit <C-r>=expand("%:p:h")."/"<CR>'';
          key = "<leader>ew";
          mode = "n";
          options.desc = "Open relative to current file";
        }
      ])
    # ++ (builtins.map (i: mkKeyMap' i.mode i.key i.action)
    #   [
    #     {
    #       action = ''"_x'';
    #       key = "x";
    #       mode = [
    #         "n"
    #         "v"
    #       ];
    #     }
    #     {
    #       action = ''"_X'';
    #       key = "X";
    #       mode = [
    #         "n"
    #         "v"
    #       ];
    #     }
    #     {
    #       action = ''"_c'';
    #       key = "c";
    #       mode = [
    #         "n"
    #         "v"
    #       ];
    #     }
    #     {
    #       action = ''"_C'';
    #       key = "C";
    #       mode = [
    #         "n"
    #         "v"
    #       ];
    #     }
    #   ])
    ++ (builtins.map (i: mkKeyMapWithOpts i.mode i.key i.action i.options.desc (builtins.removeAttrs i.options ["desc"]))
      [
        {
          action = ''(v:count > 5 ? "m'" . v:count : "") . "k"'';
          key = "k";
          mode = "n";
          options = {
            expr = true;
            desc = "Mutate jumplist with more than 5 lines up";
          };
        }
        {
          action = ''(v:count > 5 ? "m'" . v:count : "") . "j"'';
          key = "j";
          mode = "n";
          options = {
            expr = true;
            desc = "Mutate jumplist with more than 5 lines down";
          };
        }
        {
          action = ''getcmdtype() == ":" ? expand("%:h")."/" : "%%"'';
          key = "%%";
          mode = "c";
          options = {
            expr = true;
            desc = "Open relative to current file";
          };
        }
        {
          action = ''v:count || mode(1)[0:1] == "no" ? "j" : "gj"'';
          key = "j";
          mode = [
            "n"
            "x"
          ];
          options = {
            expr = true;
            desc = "Move down wrapped";
          };
        }
        {
          action = ''v:count || mode(1)[0:1] == "no" ? "k" : "gk"'';
          key = "k";
          mode = [
            "n"
            "x"
          ];
          options = {
            expr = true;
            desc = "Move up wrapped";
          };
        }
      ]);
  my.wKeyList = [
    (wKeyObj ["[" "" "next"])
    (wKeyObj ["]" "" "prev"])
    (wKeyObj ["z" "" "fold"])
  ];
}
