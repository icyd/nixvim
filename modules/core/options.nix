{
  flake.modules.nixvim.core = {
    lib,
    config,
    ...
  }: let
    disabledPlugins =
      lib.listToAttrs
      (map (p: {
          name = "loaded_${p}";
          value = 1;
        })
        config.disabledPlugins);
  in {
    clipboard.register = "unnamedplus";
    diagnostic.settings = {
      virtual_lines.current_line = true;
    };
    extraConfigLuaPre = ''
      function bool2str(bool) return bool and "enabled" or "disabled" end
    '';
    extraConfigLua = ''
      vim.opt.diffopt = vim.opt.diffopt:append("vertical")
      vim.opt.shortmess = vim.opt.shortmess:append("aAWIc")
    '';
    globals =
      disabledPlugins
      // {
        hlsearch = false;
        netrw_banner = 0;
        netrw_keepdir = 0;
        netrw_liststyle = 3;
        netrw_browse_split = 4;
        netrw_winsize = 30;
        netrw_localcopydircmd = "cp -r";
        loaded_node_provider = 1;
        loaded_perl_provider = 1;
        loaded_python3_provider = 1;
        loaded_ruby_provider = 1;
        snips_author = config.userdata.name;
        snips_email = config.userdata.email;
      };
    globalOpts.hlsearch = false;
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
      foldexpr.__raw = "vim.treesitter.foldexpr()";
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
