local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

local utils = require("custom.utils")

augroup("terminal_settings", { clear = true })
autocmd("TermOpen", {
  group = "terminal_settings",
  pattern = "",
  command = "setlocal nonumber",
})

-- Disable highlighting for sql files.
-- treesitter will handle syntax highlighting if the file isn't too large in size
augroup("sql", { clear = true })
autocmd("BufEnter", {
  group = "sql",
  pattern = "*.sql",
  command = "setlocal syntax=off",
})
autocmd("FileType", {
  group = "sql",
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    vim.keymap.set(
      "n",
      "<leader>e",
      ":normal vip<CR><Plug>(DBUI_ExecuteQuery)",
      { buffer = true, desc = "[E]xecute SQL query under cursor" }
    )
    vim.keymap.set(
      { "v", "x" },
      "<leader>e",
      "<Plug>(DBUI_ExecuteQuery)",
      { buffer = true, desc = "[E]xecute SQL query under cursor" }
    )
  end
})
autocmd("FileType", {
  group = "sql",
  pattern = "dbout",
  callback = function()
    vim.keymap.set(
      "n",
      "<CR>",
      "<Plug>(DBUI_JumpToForeignKey)",
      { buffer = true, desc = "Jump to foreign key" }
    )
  end
})

-- Turn on spell checking in markdown and git commit buffers
augroup("spell_checking", { clear = true })
autocmd("FileType", {
  group = "spell_checking",
  pattern = "markdown,gitcommit",
  command = "setlocal spell spelllang=en_us,en_gb",
})

-- Markdown filetype setup
augroup("markdown", { clear = true })
autocmd("FileType", {
  group = "markdown",
  pattern = "markdown",
  -- Conceal links and special syntax unless cursor hovering over line
  -- Also autowrap text in markdown files
  callback = function()
    vim.cmd("setlocal conceallevel=2 textwidth=90 formatoptions=cqt wrapmargin=0")
    -- Don't completely replace backticks
    vim.cmd('syntax match Entity "`" conceal cchar=`')
  end
})

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual" })
  end,
})

-- Automatically replace the ticket number in a PR markdown file created with
-- the `git-pr-create` script
augroup("replace_ticket_number_in_pr_file", { clear = true })
autocmd("BufEnter", {
  group = "replace_ticket_number_in_pr_file",
  pattern = "*.md",
  callback = function()
    if vim.fn.expand("$GIT_PR_CREATE_RAN") == "1" then
      vim.defer_fn(utils.replace_ticket_number, 10)
    end
  end,
})

-- fugitive related keymaps
augroup("git_status", { clear = true })
autocmd("FileType", {
  group = "git_status",
  pattern = "fugitive",
  callback = function()
    vim.keymap.set("n", "<Tab>", ":normal =<CR>", { buffer = true, silent = true })
    vim.keymap.set("n", "gl", "<cmd>G l<CR>", { desc = "Show git log", buffer = true })
    vim.cmd("setlocal nowrap nonumber norelativenumber")
  end,
})

-- Start in insert mode in gitcommit files
augroup("git_commit", { clear = true })
autocmd("FileType", {
  group = "git_commit",
  pattern = "gitcommit",
  callback = function()
    vim.cmd("setlocal nowrap nonumber norelativenumber textwidth=0")
    -- Start in insert mode if the current line is empty
    -- (when writing a new commit message)
    local line = vim.fn.getline(vim.fn.line("."))
    if line == nil or line == "" then
      vim.cmd("startinsert")
    end
  end
})

-- gv.vim setup
augroup("gv", { clear = true })
autocmd("FileType", {
  group = "gv",
  pattern = "GV",
  callback = function()
    vim.cmd("setlocal buftype=nofile bufhidden=wipe noswapfile nomodeline")
  end,
})
