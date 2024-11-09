local utils = require("custom.utils")

-- Clear highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

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
vim.keymap.set("n", "<leader>tq", function()
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
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd "copen"
  end
end, { desc = "[T]oggle [Q]uickfix" })

-- Window navigation
vim.keymap.set({ "n", "i", "t" }, "<C-w><C-h>", "<cmd>NvimTmuxNavigateLeft<CR>", { desc = "Go to left window" })
vim.keymap.set({ "n", "i", "t" }, "<C-w><C-j>", "<cmd>NvimTmuxNavigateDown<CR>", { desc = "Go to bottom window" })
vim.keymap.set({ "n", "i", "t" }, "<C-w><C-k>", "<cmd>NvimTmuxNavigateUp<CR>", { desc = "Go to above window" })
vim.keymap.set({ "n", "i", "t" }, "<C-w><C-l>", "<cmd>NvimTmuxNavigateRight<CR>", { desc = "Go to right window" })

-- Close tab
vim.keymap.set("n", "<C-w>q", "<cmd> tabclose<CR>", { desc = "Close the current tab" })

-- Make this a no-op as I use <C-c> to cancel the which key popup
vim.keymap.set("n", "<C-w><C-c>", "<Nop>")

-- Close all tabs except current one
vim.keymap.set("n", "<C-w>t", "<cmd> tabonly<CR>", { desc = "Close all other tabs" })

-- Open a new tab
vim.keymap.set("n", "<C-w>N", "<cmd> tabnew<CR>", { desc = "Create a new tab" })

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

-- Enter normal-mode in nvim terminal
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { desc = "Terminal normal-mode" })

-- Exit the current window
vim.keymap.set("n", "<C-q>", "<cmd> q<CR>", { desc = "Close window" })

-- Treat Ctrl+C exactly like <Esc>
vim.keymap.set({ "n", "i", "x", "o" }, "<C-c>", "<Esc>", { desc = "Escape" })

-- Center screen when moving through search results
vim.keymap.set("n", "n", "nzzzv", { desc = "Next match" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous match" })

-- Git status
vim.keymap.set("n", "<leader>gg", function()
  -- Open the git window in a horizontal split if the
  -- width of the current window is low, otherwise open it in a vertical split
  local width = vim.api.nvim_win_get_width(0)
  local status, err
  if width < 150 then
    ---@diagnostic disable-next-line: param-type-mismatch
    status, err = pcall(vim.cmd, "silent Git")
  else
    ---@diagnostic disable-next-line: param-type-mismatch
    status, err = pcall(vim.cmd, "silent vertical Git")
  end

  if not status then
    utils.print(err)
  end
end, { desc = "[G]it [G]et" })

-- Git commands
vim.keymap.set("n", "<leader>gpp", "<cmd> Git push<CR>", { desc = "[G]it [P]ush" })
vim.keymap.set("n", "<leader>gpf", "<cmd> Git push --force<CR>", { desc = "[G]it [P]ush [F]orce" })
vim.keymap.set({ "n", "v" }, "<leader>gy", ":GBrowse!<CR>", { silent = true, desc = "[G]it [Y]ank URL" })

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

-- Select custom command to run from a visual prompt
vim.keymap.set("n", "<leader>p", function()
  local commands = {
    ["da (delete all other buffers)"] = function()
      vim.cmd("%bd|e#|bd#")
    end,
    ["db (dashboard)"] = function()
      MiniStarter.open()
    end,
    ["fx (make file executable)"] = function()
      utils.run_job(
        "chmod",
        { "+x", vim.fn.expand("%") },
        "Marked " .. vim.fn.expand("%") .. " as executable"
      )
    end,
    ["gp (git pull)"] = function()
      vim.cmd("Git pull")
    end,
    ["gub (git update base worktree)"] = function()
      vim.cmd("!gitw-update")
    end,
    ["grb (git rebase with base worktree)"] = function()
      vim.cmd("!gitw-rebase")
    end,
    ["dvb (diff view base)"] = function()
      vim.cmd(":DiffviewOpen origin/master...HEAD")
    end,
    ["rv (repository view)"] = function()
      utils.run_job("gh", { "rv" }, false)
    end,
    ["prv (pull request view)"] = function()
      local pr_number_json = vim.fn.trim(vim.fn.system("gh pr view --json number"))
      if vim.v.shell_error ~= 0 then
        M.print_err(pr_number_json)
        return
      end

      local pr_number = vim.fn.trim(vim.fn.system("echo '" .. pr_number_json .. "' | jq '.number'"))
      if vim.v.shell_error ~= 0 then
        M.print_err(pr_number)
        return
      end

      vim.cmd(":tabnew")
      vim.cmd(":Octo pr edit " .. pr_number)
    end,
    ["ss (save session)"] = function()
      MiniSessions.write("Session.vim")
    end,
    ["ti (open ticket)"] = function()
      local ticket_number = vim.fn.trim(vim.fn.system("get-ticket-number"))
      if vim.v.shell_error ~= 0 then
        M.print_err(ticket_number)
        return
      end

      local base_url = vim.fn.expand("$BASE_TICKETS_URL")
      if base_url == "$BASE_TICKETS_URL" then
        M.print_err("BASE_TICKETS_URL environment variable is not set!")
        return
      end

      vim.cmd(":Browse " .. base_url .. "" .. ticket_number)
    end,
  }

  local cmd = utils.get_project_linting_cmd()
  if cmd ~= nil then
    commands["l (lint)"] = function()
      utils.run_command_in_term(table.concat(cmd, " "))
    end
  end

  local has_makefile = vim.fn.executable("make") and vim.fn.empty(vim.fn.glob("Makefile")) == 0
  if has_makefile then
    commands["ml (make lint)"] = function()
      utils.run_command_in_term("make lint")
    end
    commands["mt (make test)"] = function()
      utils.run_command_in_term("make test")
    end
    commands["ms (make shell)"] = function()
      utils.run_command_in_term("make shell")
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
