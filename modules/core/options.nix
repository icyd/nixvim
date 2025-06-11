{
  flake.modules.nixvim.core = {
    clipboard.register = "unnamedplus";
    extraConfigLua = ''
      vim.opt.diffopt = vim.opt.diffopt:append("vertical")
      vim.opt.shortmess = vim.opt.shortmess:append("aAWIc")
    '';
    globals = {
      netrw_banner = 0;
      netrw_keepdir = 0;
      netrw_liststyle = 3;
      netrw_browse_split = 4;
      netrw_winsize = 30;
      netrw_localcopydircmd = "cp -r";
    };
    opts = let
      indent = 4;
    in {
      background = "dark";
      colorcolumn = "79";
      conceallevel = 2;
      concealcursor = "nc";
      completeopt = "menu,menuone,noselect";
      expandtab = true;
      fileencoding = "utf-8";
      fileformat = "unix";
      foldlevel = 99;
      foldlevelstart = 99;
      foldmethod = "expr";
      foldexpr = "nvim_treesitter#foldexpr()";
      foldnestmax = 8;
      grepprg = "rg --vimgrep --smart-case --follow --hidden";
      history = 2000;
      ignorecase = true;
      infercase = true;
      laststatus = 3;
      list = true;
      listchars = {
        nbsp = "~";
        extends = "»";
        precedes = "«";
        tab = "▷─";
        trail = "•";
        eol = "¬";
      };
      mouse = "n";
      number = true;
      relativenumber = true;
      shiftwidth = indent;
      scrolloff = 4;
      showmatch = true;
      showmode = false;
      smartcase = true;
      splitbelow = true;
      splitright = true;
      shell = "nu";
      softtabstop = indent;
      termguicolors = true;
      undofile = true;
      wildignorecase = true;
      wildignore = [
        "*.pyc"
        "*_build/*"
        "**/coverage/*"
        "**/node_modules/*"
        "**/android/*"
        "**/ios/*"
        "**/.git/*"
      ];
      wildmode = "longest,full";
    };
  };
}
