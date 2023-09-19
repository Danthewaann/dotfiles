local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

augroup("highlight_cursorline", { clear = true })
autocmd("InsertEnter", {
    group = "highlight_cursorline",
    pattern = "",
    command = "set cursorline",
})
autocmd("InsertLeave", {
    group = "highlight_cursorline",
    pattern = "",
    command = "set nocursorline",
})

augroup("terminal_settings", { clear = true })
autocmd("TermOpen", {
    group = "terminal_settings",
    pattern = "",
    command = "setlocal nowrap nonumber norelativenumber signcolumn=no",
})
autocmd("TermClose", {
    group = "terminal_settings",
    pattern = "",
    command = "call feedkeys(\"\\<C-\\>\\<C-n>\")",
})

-- Disable highlighting for sql files.
-- treesitter will handle syntax highlighting if the file isn't too large in size
augroup("sql_dump_highlighting", { clear = true })
autocmd("BufEnter", {
    group = "sql_dump_highlighting",
    pattern = "*.sql",
    command = "setlocal syntax=off",
})

-- Use tabs instead of spaces in go files.
augroup("golang_use_tabs", { clear = true })
autocmd("FileType", {
  group = "golang_use_tabs",
  pattern = "go",
  callback = function(args)
      vim.o.expandtab = false
      -- Make sure tabs render correctly
      vim.o.tabstop = 8
      vim.o.shiftwidth = 8
  end,
})

-- Turn on spell checking in markdown and gitcommit buffers
augroup("spell_checking", { clear = true })
autocmd("FileType", {
  group = "spell_checking",
  pattern = "markdown,gitcommit",
  command = "setlocal spell spelllang=en_us,en_gb",
})

-- Go into insert mode when entering a terminal if it is running
augroup("terminal_mode", { clear = true })
autocmd("WinEnter", {
  group = "terminal_mode",
  pattern = "term://*",
  command = "if TermRunning('%') == 1 | startinsert | endif",
})

-- Start in insert mode in gitcommit files
augroup("git_commit", { clear = true })
autocmd("FileType", {
  group = "git_commit",
  pattern = "gitcommit",
  command = "startinsert",
})
