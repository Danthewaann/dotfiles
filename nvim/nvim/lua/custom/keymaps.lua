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

-- Re-select last pasted text
vim.keymap.set("n", "gV", "`[v`]", { desc = "Re-select last pasted text" })

-- Search inside the current visual selection
vim.keymap.set("x", "/", "<Esc>/\\%V", { desc = "Search inside visual selection" })

-- Keep the cursor in the same place when joining lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join with line below" })

-- Yank, comment out and paste the current line.
vim.keymap.set("n", "yc", "yy<cmd>normal gcc<CR>p", { desc = "Yank, comment out and paste line below" })

-- Go to the start and end of the line
vim.keymap.set({ "n", "v", "x", "o" }, "H", "^", { desc = "Jump to first non-blank character in line" })
vim.keymap.set({ "n", "v", "x", "o" }, "L", "g_", { desc = "Jump to last non-blank character in line" })

-- Prevent the cursor from jumping to the start of a selection after yanking it
vim.keymap.set("v", "y", "ygv<Esc>")

-- Go to alternative buffer
vim.keymap.set("n", "<BS>", ":b#<CR>zz", { silent = true, desc = "Go to alternative buffer" })

-- Vertical navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Jump half page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Jump half page up" })
vim.keymap.set("n", "<M-d>", "<C-e>", { desc = "Scroll page down" })
vim.keymap.set("n", "<M-u>", "<C-y>", { desc = "Scroll page up" })
vim.keymap.set("n", "gg", "ggzz", { desc = "Jump to first line" })
vim.keymap.set("n", "G", "Gzz", { desc = "Jump to last line" })
vim.keymap.set("n", "{", "{zz", { desc = "Jump to next paragraph" })
vim.keymap.set("n", "}", "}zz", { desc = "Jump to previous paragraph" })

-- Jump list navigation
vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "Next jump" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "Previous jump" })

-- Quickfix list
vim.keymap.set("n", "<M-l>", function()
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
end, { desc = "Toggle Quickfix" })


-- Quickfix navigation
vim.keymap.set("n", "<M-j>", function()
  local ok, _ = pcall(function() vim.cmd(":cnext") end)
  if not ok then
    ok, _ = pcall(function() vim.cmd(":cfirst") end)
    if ok then
      vim.fn.feedkeys("zz")
    end
  else
    vim.fn.feedkeys("zz")
  end
end, { desc = "Jump to next qf item" })
vim.keymap.set("n", "<M-k>", function()
  local ok, _ = pcall(function() vim.cmd(":cprevious") end)
  if not ok then
    ok, _ = pcall(function() vim.cmd(":clast") end)
    if ok then
      vim.fn.feedkeys("zz")
    end
  else
    vim.fn.feedkeys("zz")
  end
end, { desc = "Jump to previous qf item" })
vim.keymap.set("n", "g<M-j>", "<cmd> clast<CR>", { desc = "Jump to last qf item" })
vim.keymap.set("n", "g<M-k>", "<cmd> cfirst<CR>", { desc = "Jump to first qf item" })

-- Window navigation
vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd> wincmd h<CR>", { desc = "Go to left window" })
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd> wincmd j<CR>", { desc = "Go to bottom window" })
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd> wincmd k<CR>", { desc = "Go to above window" })
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd> wincmd l<CR>", { desc = "Go to right window" })

-- Close window
vim.keymap.set("n", "<C-q>", "<cmd> quit<CR>", { desc = "Close the current window" })

-- Close tab
vim.keymap.set({ "n", "t" }, "<C-w>q", "<cmd> tabclose<CR>", { desc = "Close the current tab" })

-- Close all tabs except current one
vim.keymap.set({ "n", "t" }, "<C-w><C-o>", "<cmd> tabonly<CR>", { desc = "Close other tabs" })

-- Enter normal-mode in nvim terminal
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { desc = "Terminal normal-mode" })
vim.keymap.set("t", "<C-u>", "<C-\\><C-n><C-u>", { desc = "Terminal normal-mode and scroll half a page up" })

-- Tab navigation
vim.keymap.set({ "n", "t" }, "<C-w><C-h>", "<cmd> silent tabprevious<CR>", { desc = "Go to previous tab" })
vim.keymap.set({ "n", "t" }, "<C-w><C-l>", "<cmd> silent tabnext<CR>", { desc = "Go to next tab" })

-- Go to tab by number
vim.keymap.set({ "n", "t" }, "<C-w>1", "<cmd> tabn1<CR>", { desc = "Go to tab 1" })
vim.keymap.set({ "n", "t" }, "<C-w>2", "<cmd> tabn2<CR>", { desc = "Go to tab 2" })
vim.keymap.set({ "n", "t" }, "<C-w>3", "<cmd> tabn3<CR>", { desc = "Go to tab 3" })
vim.keymap.set({ "n", "t" }, "<C-w>4", "<cmd> tabn4<CR>", { desc = "Go to tab 4" })
vim.keymap.set({ "n", "t" }, "<C-w>5", "<cmd> tabn5<CR>", { desc = "Go to tab 5" })
vim.keymap.set({ "n", "t" }, "<C-w>6", "<cmd> tabn6<CR>", { desc = "Go to tab 6" })
vim.keymap.set({ "n", "t" }, "<C-w>7", "<cmd> tabn7<CR>", { desc = "Go to tab 7" })
vim.keymap.set({ "n", "t" }, "<C-w>8", "<cmd> tabn8<CR>", { desc = "Go to tab 8" })
vim.keymap.set({ "n", "t" }, "<C-w>9", "<cmd> tabn9<CR>", { desc = "Go to tab 9" })
vim.keymap.set({ "n", "t" }, "<C-w>0", "<cmd> tablast<CR>", { desc = "Go to the last tab" })

-- Move tabs left or right
vim.keymap.set({ "n", "t" }, "<C-w>,", "<cmd> silent -tabmove<CR>", { desc = "Move tab left" })
vim.keymap.set({ "n", "t" }, "<C-w>.", "<cmd> silent +tabmove<CR>", { desc = "Move tab right" })

-- Make this a no-op as I use <C-c> to cancel the which key popup
vim.keymap.set({ "n", "t" }, "<C-w><C-c>", "<Nop>")

-- Resize the current window
vim.keymap.set("n", "<M-Left>", function()
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
vim.keymap.set("n", "<M-Right>", function()
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
vim.keymap.set("n", "<M-Down>", function()
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
vim.keymap.set("n", "<M-Up>", function()
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

-- Treat Ctrl+C exactly like <Esc>
vim.keymap.set({ "n", "i", "x", "o" }, "<C-c>", "<Esc>", { desc = "Escape" })

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

vim.keymap.set("n", "<leader>dB", function()
  vim.cmd("%bd|e#|bd#")
end, { desc = "[D]elete All Other [B]uffers" })

vim.keymap.set("n", "<leader>yf", function()
  local path = vim.fn.expand("%")
  local cb_opts = vim.opt.clipboard:get()
  if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", path) end
  if vim.tbl_contains(cb_opts, "unnamedplus") then
    vim.fn.setreg("+", path)
  end
  vim.fn.setreg("", path)
  utils.print("Copied " .. path .. " to clipboard")
end, { desc = "[Y]ank current [F]ile path" })

vim.keymap.set("n", "<leader>tb", function()
  local cur_dur = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h")
  local cmd = { "tmux", "new-window", "-c", cur_dur }
  utils.print(table.concat(cmd, " "))
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    utils.print_err(vim.fn.trim(obj.stderr))
  end
end, { desc = "Open [T]erminal in current [B]uffer directory" })

-- Folds
vim.keymap.set("n", "gl", function()
  local line = vim.fn.line(".")
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
  end
end, { desc = "Toggle fold" })

vim.keymap.set("n", "gL", function()
  local line = vim.fn.line(".")
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! zA")
  end
end, { desc = "Toggle fold recursively" })

-- Spelling
vim.keymap.set("i", "<C-l>", "<Esc>[s1z=gi", {
  desc = "Fix last spelling mistake whilst persisting the cursor position",
})
