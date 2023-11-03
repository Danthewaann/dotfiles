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
    vim.keymap.set("n", "gf", function()
      -- Get the current sequence of non-blank characters
      vim.cmd(":normal viW")
      local selection = utils.get_visual_selection()

      -- Separate the path from the potential line number
      -- e.g. some/path/to/file:42:
      --      ^ path            ^ line number
      local t = {}
      for str in string.gmatch(selection, "([^:]*)") do
        t[#t + 1] = str
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
  command = "if TermRunning('%') == 1 | startinsert | endif",
})

-- Start in insert mode in gitcommit files
augroup("git_commit", { clear = true })
autocmd("FileType", {
  group = "git_commit",
  pattern = "gitcommit",
  command = "startinsert",
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
  callback = function(events)
    local ft = vim.api.nvim_buf_get_option(events.buf, "filetype")
    if ft == "TelescopePrompt" then
      vim.defer_fn(function()
        local line_data = vim.api.nvim_win_get_cursor(0)    -- returns {row, col}
        local fold_closed = vim.fn.foldclosed(line_data[1]) -- -1 if no fold at line
        if fold_closed ~= -1 then                           -- fold exists (not -1)
          vim.cmd([[normal! zvzczOzz]])
        end
      end, 100)
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
  end,
})

-- firenvim setup
augroup("firenvim", { clear = true })
autocmd("BufEnter", {
  group = "firenvim",
  pattern = "*firenvim*.txt",
  callback = function()
    require("lualine").hide({})
    vim.cmd.set("filetype=markdown wrap signcolumn=no nonumber statuscolumn= laststatus=0")
  end,
})
