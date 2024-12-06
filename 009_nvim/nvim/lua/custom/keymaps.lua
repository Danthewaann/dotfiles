local utils = require("custom.utils")

-- Treat <space> as a noop
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, desc = "No-op" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })

-- Move the current selection up or down a line
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection up a line", silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection down a line", silent = true })

-- Re-select visual selection when indenting it
vim.keymap.set("v", ">", ">gv", { desc = "Increase indent" })
vim.keymap.set("v", "<", "<gv", { desc = "Decrease indent" })

-- Keep the cursor in the same place when joining lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join with line below" })

-- Map enter to break the current line
vim.keymap.set("n", "<CR>", "i<CR><ESC>k$", { desc = "Add linebreak" })

-- Re-select last pasted text
vim.keymap.set("n", "gp", "`[v`]", { desc = "Re-select last pasted text" })

-- Go to the start and end of the line
vim.keymap.set("n", "H", "0", { desc = "Jump to start of line" })
vim.keymap.set("n", "L", "$", { desc = "Jump to end of line" })
vim.keymap.set({ "v", "x", "o" }, "H", "_", { desc = "Jump to first non-blank character in line" })
vim.keymap.set({ "v", "x", "o" }, "L", "g_", { desc = "Jump to last non-blank character in line" })

-- Prevent the cursor from jumping to the start of a selection after yanking it
vim.keymap.set("v", "y", "ygv<Esc>")

-- Go to alternative buffer
vim.keymap.set("n", "<BS>", ":b#<CR>", { silent = true, desc = "Go to alternative buffer" })

-- Vertical navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Go half page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Go half page up" })
vim.keymap.set("n", "gg", "ggzz", { desc = "First line" })
vim.keymap.set("n", "G", "Gzz", { desc = "Last line" })
vim.keymap.set("n", "{", "{zz", { desc = "Next paragraph" })
vim.keymap.set("n", "}", "}zz", { desc = "Previous paragraph" })

-- Jump list navigation
vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "Next jump" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "Previous jump" })

-- Quickfix list
vim.keymap.set("n", "<C-e>", function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
    return
  end
  vim.cmd "botright copen"
end, { desc = "[T]oggle [Q]uickfix" })

-- Window navigation
vim.keymap.set({ "n", "i", "t" }, "<C-w><C-h>", "<cmd>NvimTmuxNavigateLeft<CR>", { desc = "Go to left window" })
vim.keymap.set({ "n", "i", "t" }, "<C-w>h", "<cmd>NvimTmuxNavigateLeft<CR>", { desc = "Go to left window" })
vim.keymap.set({ "n", "i", "t" }, "<C-w><C-j>", "<cmd>NvimTmuxNavigateDown<CR>", { desc = "Go to bottom window" })
vim.keymap.set({ "n", "i", "t" }, "<C-w>j", "<cmd>NvimTmuxNavigateDown<CR>", { desc = "Go to bottom window" })
vim.keymap.set({ "n", "i", "t" }, "<C-w><C-k>", "<cmd>NvimTmuxNavigateUp<CR>", { desc = "Go to above window" })
vim.keymap.set({ "n", "i", "t" }, "<C-w>k", "<cmd>NvimTmuxNavigateUp<CR>", { desc = "Go to above window" })
vim.keymap.set({ "n", "i", "t" }, "<C-w><C-l>", "<cmd>NvimTmuxNavigateRight<CR>", { desc = "Go to right window" })
vim.keymap.set({ "n", "i", "t" }, "<C-w>l", "<cmd>NvimTmuxNavigateRight<CR>", { desc = "Go to right window" })

-- Close window
vim.keymap.set("n", "<C-q>", "<cmd> quit<CR>", { desc = "Close the current window" })

-- Close tab
vim.keymap.set("n", "<C-w>q", "<cmd> tabclose<CR>", { desc = "Close the current tab" })

-- Enter normal-mode in nvim terminal
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { desc = "Terminal normal-mode" })

-- Tab navigation
vim.keymap.set("n", "<C-t><C-h>", "<cmd> silent tabprevious<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<C-t><C-l>", "<cmd> silent tabnext<CR>", { desc = "Go to next tab" })

-- Go to tab by number
vim.keymap.set("n", "<C-w>1", "<cmd> tabn1<CR>", { desc = "Go to tab 1" })
vim.keymap.set("n", "<C-w>2", "<cmd> tabn2<CR>", { desc = "Go to tab 2" })
vim.keymap.set("n", "<C-w>3", "<cmd> tabn3<CR>", { desc = "Go to tab 3" })
vim.keymap.set("n", "<C-w>4", "<cmd> tabn4<CR>", { desc = "Go to tab 4" })
vim.keymap.set("n", "<C-w>5", "<cmd> tabn5<CR>", { desc = "Go to tab 5" })
vim.keymap.set("n", "<C-w>6", "<cmd> tabn6<CR>", { desc = "Go to tab 6" })
vim.keymap.set("n", "<C-w>7", "<cmd> tabn7<CR>", { desc = "Go to tab 7" })
vim.keymap.set("n", "<C-w>8", "<cmd> tabn8<CR>", { desc = "Go to tab 8" })
vim.keymap.set("n", "<C-w>9", "<cmd> tabn9<CR>", { desc = "Go to tab 9" })
vim.keymap.set("n", "<C-w>0", "<cmd> tablast<CR>", { desc = "Go to the last tab" })

-- Move tabs left or right
vim.keymap.set("n", "<C-w>,", "<cmd> silent -tabmove<CR>", { desc = "Move tab left" })
vim.keymap.set("n", "<C-w>.", "<cmd> silent +tabmove<CR>", { desc = "Move tab right" })

-- Make this a no-op as I use <C-c> to cancel the which key popup
vim.keymap.set("n", "<C-w><C-c>", "<Nop>")

-- Resize the current window
vim.keymap.set("n", "<M-h>", function()
  local cur_winnr = vim.api.nvim_get_current_win()
  vim.cmd(":wincmd h")
  local other_winnr = vim.api.nvim_get_current_win()

  if cur_winnr == other_winnr then
    vim.cmd(":vertical resize-5")
  else
    vim.cmd(":vertical resize-5")
    vim.cmd(":wincmd p")
  end
end, { desc = "Adjust window width left" })
vim.keymap.set("n", "<M-l>", function()
  local cur_winnr = vim.api.nvim_get_current_win()
  vim.cmd(":wincmd l")
  local other_winnr = vim.api.nvim_get_current_win()

  if cur_winnr == other_winnr then
    vim.cmd(":vertical resize-5")
  else
    vim.cmd(":vertical resize-5")
    vim.cmd(":wincmd p")
  end
end, { desc = "Adjust window width right" })
vim.keymap.set("n", "<M-j>", function()
  local cur_winnr = vim.api.nvim_get_current_win()
  vim.cmd(":wincmd j")
  local other_winnr = vim.api.nvim_get_current_win()

  if cur_winnr == other_winnr then
    vim.cmd(":resize-5")
  else
    vim.cmd(":resize-5")
    vim.cmd(":wincmd p")
  end
end, { desc = "Adjust window height up" })
vim.keymap.set("n", "<M-k>", function()
  local cur_winnr = vim.api.nvim_get_current_win()
  vim.cmd(":wincmd k")
  local other_winnr = vim.api.nvim_get_current_win()

  if cur_winnr == other_winnr then
    vim.cmd(":resize-5")
  else
    vim.cmd(":resize-5")
    vim.cmd(":wincmd p")
  end
end, { desc = "Adjust window height down" })

-- Center screen when moving through search results
vim.keymap.set("n", "n", "nzzzv", { desc = "Next match" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous match" })

-- Replace current word in current file
vim.keymap.set("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "[R]e[p]lace current word in file" }
)

-- Replace visual selection in current file
vim.keymap.set("v", "<leader>rp", [["ky:%s/<C-r>=escape(@k, "/")<CR>/<C-r>=escape(@k, "/")<CR>/gI<Left><Left><Left>]],
  { desc = "[R]e[p]lace selection in file" }
)

-- Use <C-P> and <C-N> to cycle through history in vim command mode
-- This is needed to allow command line completion to work properly
vim.keymap.set("c", "<C-p>", "<Up>", { desc = "Previous command" })
vim.keymap.set("c", "<C-n>", "<Down>", { desc = "Next command" })

-- Disable Tab and Shift-Tab in command line to let nvim-cmp handle completion over wildmenu
vim.keymap.set("c", "<Tab>", "<Nop>")
vim.keymap.set("c", "<S-Tab>", "<Nop>")

-- Select custom command to run from a visual prompt
vim.keymap.set("n", "<leader>p", function()
  local commands = {
    ["cj  (create new journal entry)"] = function()
      local template
      local workspace = os.getenv("TMUX_CURRENT_DIR")
      if workspace ~= nil and utils.file_exists(workspace) then
        template = workspace .. "/notes/journal/template.md"
      end

      vim.ui.input({ prompt = "Enter year", default = os.date("%Y") }, function(input)
        if input == nil then
          return
        end

        local year = input
        vim.ui.input({ prompt = "Enter week", default = os.date("%W") }, function(input2)
          if input2 == nil then
            return
          end

          local week = input2
          local file_week = week
          if tonumber(file_week) < 10 then
            file_week = "0" .. file_week
          end
          local journal_entry = workspace .. "/notes/journal/" .. year .. "/week-" .. file_week .. ".md"
          local obj = vim.system({ "create-journal-entry", template, journal_entry, year, week }, { text = true }):wait()
          if obj.code ~= 0 then
            M.print_err(obj.stderr)
            return
          end
          vim.cmd(":e " .. journal_entry)
        end)
      end)
    end,
    ["da  (delete all other buffers)"] = function()
      vim.cmd("%bd|e#|bd#")
    end,
    ["fx  (make file executable)"] = function()
      utils.run_job(
        "chmod",
        { "+x", vim.fn.expand("%") },
        "Marked " .. vim.fn.expand("%") .. " as executable"
      )
    end,
    ["ss  (save session)"] = function()
      MiniSessions.write("Session.vim")
    end,
  }

  local cmd = utils.get_project_linting_cmd()
  if cmd ~= nil then
    commands["l   (lint)"] = function()
      utils.run_command_in_term(table.concat(cmd, " "))
    end
  end

  local keys = vim.tbl_keys(commands)
  table.sort(keys)

  vim.ui.select(
    keys,
    { prompt = "Command prompt" },
    function(choice)
      for key, value in pairs(commands) do
        if choice == key then
          value()
          return
        end
      end
    end
  )
end, { desc = "Command [P]rompt" })

vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", {
  desc = "Fix last spelling mistake whilst persisting the cursor position",
})
