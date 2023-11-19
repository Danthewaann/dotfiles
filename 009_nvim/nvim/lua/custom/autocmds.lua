local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local bufmap = vim.api.nvim_buf_set_keymap

local utils = require("custom.utils")

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
        vim.api.nvim_echo({ { "File not found!", "ErrorMsg" } }, true, {})
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

      utils.unfold()
    end, { buffer = 0, silent = true })
  end,
})
autocmd("TermClose", {
  group = "terminal_settings",
  pattern = "",
  command = 'call feedkeys("\\<C-\\>\\<C-n>")',
})

-- Disable highlighting for sql files.
-- treesitter will handle syntax highlighting if the file isn't too large in size
augroup("sql_dump_highlighting", { clear = true })
autocmd("BufEnter", {
  group = "sql_dump_highlighting",
  pattern = "*.sql",
  command = "setlocal syntax=off",
})

-- Turn on spell checking in markdown and gitcommit buffers
augroup("spell_checking", { clear = true })
autocmd("FileType", {
  group = "spell_checking",
  pattern = "markdown,gitcommit",
  command = "setlocal spell spelllang=en_us,en_gb",
})

-- Autowrap text in markdown files
augroup("auto_wrap", { clear = true })
autocmd("FileType", {
  group = "auto_wrap",
  pattern = "markdown",
  command = "setlocal tw=90 fo=cqt wm=0",
})

-- Go into insert mode when entering a terminal if it is running
augroup("terminal_mode", { clear = true })
autocmd("WinEnter", {
  group = "terminal_mode",
  pattern = "term://*",
  callback = function()
    if utils.term_is_running(vim.fn.expand("%")) then
      vim.cmd("startinsert")
    end
  end
})

-- Start in insert mode in gitcommit files
augroup("git_commit", { clear = true })
autocmd("FileType", {
  group = "git_commit",
  pattern = "gitcommit",
  callback = function()
    vim.cmd("startinsert")
    vim.cmd("setlocal nowrap nonumber norelativenumber")
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

-- Unfold fold at cursor when leaving the TelescopePrompt
-- From:
-- * https://www.reddit.com/r/neovim/comments/twug6q/how_to_open_auto_open_fold_in_telescope_after_cr/
-- * https://www.reddit.com/r/neovim/comments/14v9xcw/zv_after_using_telescope/
-- * https://github.com/nvim-telescope/telescope.nvim/issues/2115
augroup("unfold_on_jump", { clear = true })
autocmd("BufLeave", {
  group = "unfold_on_jump",
  pattern = "*",
  callback = function()
    local ft = vim.api.nvim_get_option_value("filetype", {})
    if ft == "TelescopePrompt" then
      utils.unfold()
    end
  end,
})

-- fugitive related keymaps
augroup("git_status", { clear = true })
autocmd("FileType", {
  group = "git_status",
  pattern = "fugitive",
  callback = function()
    bufmap(0, "n", "<Tab>", ":normal =<CR>", { silent = true })
    vim.cmd("setlocal nowrap nonumber norelativenumber")
  end,
})

-- firenvim setup
augroup("firenvim", { clear = true })
autocmd("BufEnter", {
  group = "firenvim",
  pattern = "*firenvim*.txt",
  callback = function()
    ---@diagnostic disable-next-line: missing-fields
    require("lualine").hide({})
    vim.cmd.set("filetype=markdown wrap signcolumn=no nonumber statuscolumn= laststatus=0")
  end,
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

-- Automatically replace the ticket number in a PR markdown file created with
-- the `git-pr-create` script
augroup("replace_ticket_number_in_pr_file", { clear = true })
autocmd("BufEnter", {
  group = "replace_ticket_number_in_pr_file",
  pattern = "*.md",
  callback = function()
    if vim.fn.expand("$GIT_PR_CREATE_RAN") == "1" then
      utils.replace_ticket_number()
    end
  end,
})

-- quickfix list setup
augroup("quickfix", { clear = true })
autocmd("FileType", {
  group = "quickfix",
  pattern = "qf",
  callback = function(e)
    -- Cycle through different quickfix lists
    vim.keymap.set("n", "<C-o>", "<cmd>colder<CR>", { buffer = e.buf })
    vim.keymap.set("n", "<C-i>", "<cmd>cnewer<CR>", { buffer = e.buf })
  end,
})

-- Save and load views on buffer enter and exit
-- From: https://github.com/kevinhwang91/nvim-ufo/issues/115#issuecomment-1436059023
augroup("load_and_save_views", { clear = true })
autocmd("BufWinEnter", {
  group = "load_and_save_views",
  pattern = "*",
  command = "silent! loadview"
})
autocmd("BufWinLeave", {
  group = "load_and_save_views",
  pattern = "*",
  command = "silent! mkview"
})
