local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

local utils = require("custom.utils")

augroup("terminal_settings", { clear = true })
autocmd("TermOpen", {
  group = "terminal_settings",
  pattern = "",
  command = "setlocal signcolumn=no nonumber",
})
-- For a running terminal emulator that contains file paths that I would like to
-- jump to in another buffer within the same window
autocmd("TermOpen", {
  group = "terminal_settings",
  pattern = "",
  callback = function()
    vim.keymap.set({ "n", "x" }, "gf", function()
      -- Get the current sequence of non-blank characters
      if vim.fn.mode() == "n" then
        vim.cmd(":normal viW")
      end

      local selection = utils.get_visual_selection()

      -- Separate the path from the potential line number
      -- e.g. some/path/to/file:42:
      --      ^ path            ^ line number
      local t = {}
      for str in string.gmatch(selection, "([^:]*)") do
        t[#t + 1] = str
      end

      -- Check if the file exists
      if not utils.file_exists(t[1]) then
        utils.print_err("File not found!")
        return
      end

      -- Jump back to the previous buffer
      vim.cmd(":wincmd p")

      -- If a line number was found, open the file and jump to that line number.
      -- If a name was found, just to that name in the file,
      -- otherwise just open the file
      if t[3] ~= "" then
        vim.cmd(":e +" .. t[3] .. " " .. t[1])
      elseif t[4] ~= "" then
        vim.cmd(":e +/" .. t[4] .. " " .. t[1])
      else
        vim.cmd(":e " .. t[1])
      end
    end, { buffer = 0, silent = true })
  end,
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
