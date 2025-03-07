local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local utils = require("custom.utils")

autocmd("TermOpen", {
  group = augroup("terminal_settings", { clear = true }),
  pattern = "",
  callback = function()
    vim.cmd(":setlocal nonumber signcolumn=no nocursorline")
    -- Remove newlines when yanking the visual selection
    -- Needed for the neovim terminal as it insert newlines
    -- when a line is too long for the screen
    vim.keymap.set("v", "<leader>y", function()
      local lines = {}
      for s in utils.get_visual_selection():gmatch("[^\n]+") do
        table.insert(lines, s)
      end

      vim.fn.setreg("+", table.concat(lines))
    end, { buffer = 0, desc = "[Y]ank selection and remove line breaks" })

    local function jump_to_file(in_tab)
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

      -- Jump back to the first tab or the last window
      if in_tab then
        vim.cmd(":tabprevious")
      else
        vim.cmd(":wincmd p")
      end

      -- If a line number was found, open the file and jump to that line number.
      -- If a name was found, just to that name in the file,
      -- otherwise just open the file
      if #t == 2 then
        vim.cmd(":e " .. t[1])
      else
        if t[3] ~= "" then
          vim.cmd(":e +" .. t[3] .. " " .. t[1])
        elseif t[4] ~= "" then
          -- Split on `[` character as pytest data driven tests contain the sub test name that can't be searched
          local s = {}
          for str in string.gmatch(t[4], "([^\\[]*)") do
            s[#s + 1] = str
          end
          vim.cmd(":e +/" .. s[1] .. " " .. t[1])
        end
      end
    end

    -- For a running terminal emulator that contains file paths that I would like to jump to in another buffer
    vim.keymap.set({ "n", "x" }, "gf", function() jump_to_file(false) end, { buffer = 0, silent = true })
    vim.keymap.set({ "n", "x" }, "<C-w>gf", function() jump_to_file(true) end, { buffer = 0, silent = true })
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
      ":normal mavip<CR><Plug>(DBUI_ExecuteQuery)`a",
      { silent = true, buffer = true, desc = "[E]xecute SQL query under cursor" }
    )
    vim.keymap.set(
      { "v", "x" },
      "<leader>e",
      "ma<Plug>(DBUI_ExecuteQuery)`a",
      { silent = true, buffer = true, desc = "[E]xecute SQL query under cursor" }
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
autocmd("FileType", {
  group = augroup("spell_checking", { clear = true }),
  pattern = "markdown,gitcommit",
  command = "setlocal spell spelllang=en_us,en_gb",
})

-- Markdown filetype setup
autocmd("FileType", {
  group = augroup("markdown", { clear = true }),
  pattern = "markdown",
  callback = function(event)
    -- Disable `render-markdown` in LSP hover documentation windows
    if vim.bo[event.buf].buftype == "nofile" then
      pcall(require("render-markdown").disable)
    else
      -- Autowrap text in markdown files
      local textwidth = 160
      vim.cmd("setlocal textwidth=" .. textwidth .. " formatoptions=cqt wrapmargin=0")
    end
  end
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    -- TODO: Highlighting a yank inside a quickfix list doesn't work
    if vim.bo[buf].filetype ~= "qf" then
      vim.highlight.on_yank({ higroup = "Visual" })
    end
  end,
})

-- Jump to the last position in the file
autocmd("BufReadPost", {
  group = augroup("jump_to_last_position", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd(":normal! g`\"")
    end
  end,
})

-- Quickfix binds
autocmd("FileType", {
  group = augroup("quickfix", { clear = true }),
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<leader>l", "<cmd> silent! colder<CR>", { buffer = 0, desc = "Open previous quickfix list" })
    vim.keymap.set("n", "<leader>n", "<cmd> silent! cnewer<CR>", { buffer = 0, desc = "Open next quickfix list" })

    -- Replace current word in current file
    vim.keymap.set("n", "<leader>rp",
      [[:cdo %s/\<<C-r><C-w>\>/<C-r><C-w>/gI | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
      { buffer = 0, desc = "[R]e[p]lace current word in qf items" }
    )

    -- Replace visual selection in current file
    -- TODO: The below bind raises an error due to the `TextYankPost` autocmd I have above
    vim.keymap.set("v", "<leader>rp",
      [["ky:cdo %s/<C-r>=escape(@k, "/")<CR>/<C-r>=escape(@k, "/")<CR>/gI | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
      { buffer = 0, desc = "[R]e[p]lace selection in qf items" }
    )
  end,
})
