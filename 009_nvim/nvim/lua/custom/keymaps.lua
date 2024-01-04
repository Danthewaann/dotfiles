local utils = require("custom.utils")

-- Treat <space> as a noop
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, desc = "No-op" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })

-- Open fold at cursor recursively
vim.keymap.set(
  "n",
  "l",
  "foldclosed('.') == -1 ? 'l' : 'zO'",
  { expr = true, silent = true, desc = "Right or open fold", }
)

-- Move the current selection up or down a line
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection up a line" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection down a line" })

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
vim.keymap.set({ "v", "x", "o" }, "L", "g_", { desc = "Jump to list non-blank character in line" })

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

-- Window navigation
vim.keymap.set({ "n", "i", "t" }, "<C-h>", "<cmd>NvimTmuxNavigateLeft<CR>", { desc = "Go to left window" })
vim.keymap.set({ "n", "i", "t" }, "<C-j>", "<cmd>NvimTmuxNavigateDown<CR>", { desc = "Go to bottom window" })
vim.keymap.set({ "n", "i", "t" }, "<C-k>", "<cmd>NvimTmuxNavigateUp<CR>", { desc = "Go to above window" })
vim.keymap.set({ "n", "i", "t" }, "<C-l>", "<cmd>NvimTmuxNavigateRight<CR>", { desc = "Go to right window" })

-- Tab navigation
vim.keymap.set("n", "<C-w><C-h>", "<cmd> silent tabprevious<CR>")
vim.keymap.set("n", "<C-w><C-l>", "<cmd> silent tabnext<CR>")

-- Close tab
vim.keymap.set("n", "<C-w>q", "<cmd> tabclose<CR>", { desc = "Close the current tab" })

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

-- Resize the current window
vim.keymap.set("n", "<M-l>", "<cmd> vertical resize+5><CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<M-h>", "<cmd> vertical resize-5<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<M-k>", "<cmd> resize-5<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<M-j>", "<cmd> resize+5<CR>", { desc = "Increase window height" })

-- Enter normal-mode in nvim terminal
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { desc = "Terminal normal-mode" })

-- Exit the current window
vim.keymap.set("n", "<C-q>", "<cmd> q<CR>", { desc = "Close window" })

-- Treat Ctrl+C exactly like <Esc>
vim.keymap.set({ "n", "i", "x", "o" }, "<C-c>", "<Esc>", { desc = "Escape" })

-- Center screen when moving through search results
vim.keymap.set("n", "n", "nzzzv", { desc = "Next match" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous match" })

-- Git commands
vim.keymap.set("n", "<leader>gpp", "<cmd> Git push<CR>", { desc = "[G]it [P]ush" })
vim.keymap.set("n", "<leader>gpf", "<cmd> Git push --force<CR>", { desc = "[G]it [P]ush [F]orce" })
vim.keymap.set("n", "<leader>gg", function()
  -- Open the git window in a horizontal split if the
  -- width of the current window is low, otherwise open it in a vertical split
  local width = vim.api.nvim_win_get_width(0)
  if width < 150 then
    vim.cmd("silent Git")
  else
    vim.cmd("silent vertical Git")
  end
end, { desc = "[G]it [G]et" })
vim.keymap.set("n", "<leader>gcc", "<cmd> silent Git commit<CR>", { desc = "[G]it [C]ommit [C]reate" })
vim.keymap.set("n", "<leader>gca", "<cmd> silent Git commit --amend<CR>", { desc = "[G]it [C]ommit [A]mend" })
vim.keymap.set("n", "<leader>gce", "<cmd> Git commit --amend --no-edit<CR>", { desc = "[G]it [C]ommit [E]dit" })
vim.keymap.set({ "n", "v" }, "<leader>go", ":GBrowse!<CR>", { silent = true, desc = "[G]it [O]pen copy url" })
vim.keymap.set("n", "<leader>ghr", function()
  print("Opening GitHub repository...")
  vim.fn.system("gh rv")
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Not in a GitHub repo!", "ErrorMsg" } }, true, {})
    return
  end
end, { desc = "[G]it [H]ub [R]epo view" })
vim.keymap.set("n", "<leader>ghv", function()
  print("Opening PR for current branch...")
  vim.fn.system("gh prv")
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Pull request not found!", "ErrorMsg" } }, true, {})
    return
  end
end, { desc = "[G]it [H]ub [V]iew pull request" })

-- Replace current word in current file
vim.keymap.set("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "[R]e[p]lace current word in file" }
)

-- Replace visual selection in current file
vim.keymap.set("v", "<leader>rp", [["ky:%s/<C-r>=@k<CR>/<C-r>=@k<CR>/gI<Left><Left><Left>]],
  { desc = "[R]e[p]lace selection in file" }
)

vim.keymap.set("n", "<leader>fx", "<cmd>!chmod +x %<CR>", { desc = "[F]ile Make [E]xecutable" })

-- Use <C-P> and <C-N> to cycle through history in vim command mode
-- This is needed to allow command line completion to work properly
vim.keymap.set("c", "<C-p>", "<Up>", { desc = "Previous command" })
vim.keymap.set("c", "<C-n>", "<Down>", { desc = "Next command" })

-- Select custom command to run from a visual prompt
vim.keymap.set("n", "<leader>cr", function()
  vim.ui.select(
    { "lint", "make lint", "make test", "make shell" },
    { prompt = "Select command to run" },
    function(choice)
      if choice == "lint" then
        local cmd = utils.get_project_linting_cmd()
        if cmd ~= nil then
          require("toggleterm").exec_command("cmd='" .. table.concat(cmd, " ") .. "'")
        end
      elseif choice == "make lint" then
        require("toggleterm").exec_command("cmd='make lint'")
      elseif choice == "make test" then
        require("toggleterm").exec_command("cmd='make test'")
      elseif choice == "make shell" then
        require("toggleterm").exec_command("cmd='make shell'")
      end
    end)
end, { desc = "[C]ommand [R]un" })
