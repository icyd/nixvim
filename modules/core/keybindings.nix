{
  flake.modules.nixvim.core = {config, ...}: let
    inherit (config.utils.mkKey) mkKeyMap wKeyObj;
  in {
    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };
    extraConfigVim = ''
      nnoremap <expr> "k" v:count ? (v:count > 5 ? "m'" . v:count : "") . "k" : "gk"
      nnoremap <expr> "j" v:count ? (v:count > 5 ? "m'" . v:count : "") . "j" : "gj"
      nnoremap "^" "g^"
      nnoremap "$" "g$"
      nnoremap "C" "\"_C"
      nnoremap "c" "\"_c"
      nnoremap "J" "mzJ`z"
      nnoremap "n" "nzzzv"
      nnoremap "N" "Nzzzv"
    '';
    keymaps =
      builtins.map mkKeyMap
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
          options.desc = "Remove search highlight";
        }
        {
          action = "y$";
          key = "Y";
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
          options.desc = "Delete and paste";
        }
        {
          action = "{zz";
          key = "{";
          options.desc = "Center on next match";
        }
        {
          action = "}zz";
          key = "}";
          options.desc = "Center on prev match";
        }
        {
          action = "<cmd>split<CR>";
          key = "<leader>-";
          options.desc = "Split horizontal";
        }
        {
          action = "<cmd>vsplit<CR>";
          key = "<leader>\\";
          options.desc = "Split vertical";
        }
        # {
        #   action = "<C-a>";
        #   key = "<M-a>";
        #   options.desc = "Increment number";
        # }
        # {
        #   action = "<C-x>";
        #   key = "<M-x>";
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
          options.desc = "Move to left window";
        }
        {
          action = "<C-w>j";
          key = "<M-j>";
          options.desc = "Move to down window";
        }
        {
          action = "<C-w>k";
          key = "<M-k>";
          options.desc = "Move to up window";
        }
        {
          action = "<C-w>l";
          key = "<M-l>";
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
          options.desc = "Move line up";
        }
        {
          action = "<cmd>move .+1<CR>==";
          key = "<C-j>";
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
          options.desc = "Open terminal";
        }
        {
          action = "<C-\\><C-N>";
          key = "<ESC>";
          mode = "t";
          options.desc = "Escape terminal with ESC";
        }
        {
          action = "<C-\\><C-N>";
          key = "<C-[>";
          mode = "t";
          options.desc = "Escape terminal with <C-[>";
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
          options.desc = "Create new tab";
        }
        {
          action = "<cmd>tabfirst<CR>";
          key = "<leader>a^";
          options.desc = "Go to first tab";
        }
        {
          action = "<cmd>tabnext<CR>";
          key = "<leader>an";
          options.desc = "Go to next tab";
        }
        {
          action = "<cmd>tabprev<CR>";
          key = "<leader>ap";
          options.desc = "Go to prev tab";
        }
        {
          action = "<cmd>tablast<CR>";
          key = "<leader>a$";
          options.desc = "Go to last tab";
        }
        {
          action = "<cmd>tabedit<CR>";
          key = "<leader>ae";
          options.desc = "Edit in new tab";
        }
        {
          action = "<cmd>tabm<Space>";
          key = "<leader>am";
          options.desc = "Tab move";
        }
        {
          action = "<cmd>tabclose<CR>";
          key = "<leader>ax";
          options.desc = "Close tab";
        }
        {
          action = "<cmd>tabnew<CR>";
          key = "<leader>ac";
          options.desc = "Create new tab";
        }
        {
          action = "<cmd>make<CR>";
          key = "<leader>X";
          options.desc = "Run Make";
        }
        {
          action = "<cmd>make<CR>";
          key = "<leader>S";
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
          options.desc = "Create new dir";
        }
        {
          action = ''<cmd>lcd %:h<CR><cmd>echo "Changed directory to: "expand("%:p:h")<CR>'';
          key = "<leader>cd";
          options.desc = "Changed directory to current file's parent";
        }
        {
          action = ''<cmd>edit <C-r>=expand("%:p:h")."/"<CR>'';
          key = "<leader>ew";
          options.desc = "Open relative to current file";
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
      ];
    utils.wKeyList = builtins.map wKeyObj [
      ["[" "" "next"]
      ["]" "" "prev"]
      ["<leader>a" "󰓩" "Tabs"]
      ["z" "" "fold"]
    ];
  };
}
