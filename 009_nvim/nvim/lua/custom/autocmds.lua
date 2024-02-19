local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

local utils = require("custom.utils")

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
  pattern = "markdown,NeogitCommitMessage",
  command = "setlocal spell spelllang=en_us,en_gb",
})

-- Markdown filetype setup
augroup("markdown", { clear = true })
autocmd("FileType", {
  group = "markdown",
  pattern = "markdown",
  -- Conceal links and special syntax unless cursor hovering over line
  -- Also autowrap text in markdown files
  command = "setlocal conceallevel=2 textwidth=90 formatoptions=cqt wrapmargin=0"
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
