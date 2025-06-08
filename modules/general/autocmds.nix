{lib, ...}: {
  autoGroups = {
    auto_create_dir.clear = true;
    auto_spell.clear = true;
    cursor_line.clear = true;
    gitcommit.clear = true;
    term_conf.clear = true;
  };
  autoCmd = with lib.nixvim.utils; [
    {
      command = "setlocal noundofile";
      desc = "Disable undofile for tmp files";
      event = "BufWritePre";
      pattern = "/tmp/*";
    }
    {
      command = "set cursorline";
      desc = "Enable cursor line in normal";
      event = [
        "InsertLeave"
        "WinEnter"
      ];
      group = "cursor_line";
    }
    {
      command = "set nocursorline";
      desc = "Disable cursor line in insert";
      event = [
        "InsertEnter"
        "WinLeave"
      ];
      group = "cursor_line";
    }
    {
      command = "setlocal spell spelllang=en tw=80";
      desc = "Enable spell on files";
      event = [
        "Bufread"
        "BufNewFile"
      ];
      group = "auto_spell";
      pattern = [
        "*.md"
        "*.txt"
        "*.pandoc"
        "*.org"
        "*.norg"
        "*.neorg"
      ];
    }
    {
      command = "setlocal spell spelllang=en_us tw=100";
      desc = "Enable spell and textwidth in gitcommit filetype";
      event = "FileType";
      group = "auto_spell";
      pattern = "gitcommit";
    }
    {
      command = "setlocal nonumber norelativenumber nocursorline signcolumn=no";
      desc = "Set terminal without numbers, cursorline or sign columns";
      event = [
        "TermOpen"
        "TermEnter"
      ];
      group = "term_conf";
      pattern = "*";
    }
    {
      command = "startinsert";
      desc = "Start terminal in insert mode";
      event = "TermOpen";
      group = "term_conf";
      pattern = "*";
    }
    {
      callback = mkRaw ''
        function(event)
            if string.match(event.match, "^oil:.*") or string.match(event.match, "^fugitive:.*") then
              return
            end
            local file = vim.loop.fs_realpath(event.match) or event.match
            local dir = vim.fn.fnamemodify(file, ":p:h")
            vim.fn.mkdir(dir, "p")
            local backup = vim.fn.fnamemodify(file, ":p:~:h")
            backup = backup:gsub("[/\\]", "%%")
            vim.go.backupext = backup
        end
      '';
      desc = "Create directory if needed when saving a file";
      event = "BufWritePre";
      group = "auto_create_dir";
    }
    {
      callback = mkRaw ''
        function()
          vim.wo.spell = false
          vim.wo.conceallevel = 0
        end
      '';
      desc = "Set config for json files";
      event = "FileType";
      pattern = "json";
    }
    {
      command = ''
        function! CompleteTx()
            execute '%s/^\(\d\{4}[\/-]\d\{2}[\/-]\d\{2}\)\ze\s\+\w/\1 */c'
        endfunction

        command! -nargs=0 CompleteTx call CompleteTx()
      '';
      desc = "Create function CompleteTx on ledger files";
      event = "FileType";
      pattern = "ledger";
    }
    {
      command = "wincmd =";
      desc = "Equalize splits on Vim resize";
      event = "VimResized";
      pattern = "*";
    }
  ];
}
