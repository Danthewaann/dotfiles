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
vim.keymap.set("x", "g/", "<Esc>/\\%V", { desc = "Search inside visual selection" })

-- Keep the cursor in the same place when joining lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join with line below" })

-- Yank, comment out and paste the current line.
vim.keymap.set("n", "yc", "yy<cmd>normal gcc<CR>p", { desc = "Yank, comment out and paste line below" })

-- Go to the start and end of the line
vim.keymap.set("n", "H", "0", { desc = "Jump to start of line" })
vim.keymap.set("n", "L", "$", { desc = "Jump to end of line" })
vim.keymap.set({ "v", "x", "o" }, "H", "_", { desc = "Jump to first non-blank character in line" })
vim.keymap.set({ "v", "x", "o" }, "L", "g_", { desc = "Jump to last non-blank character in line" })

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

vim.keymap.set("n", "<leader>ga", function()
  vim.ui.input({ prompt = "Enter branch name" }, function(input)
    if input == nil then
      return
    end

    utils.print("Creating worktree " .. input .. "...")
    local obj = vim.system({ "gitw-add", input }):wait()
    if obj.code ~= 0 then
      utils.print_err(vim.fn.trim(obj.stderr))
      return
    end
  end)
end, { desc = "[G]it Worktree [A]dd" })

vim.keymap.set("n", "<leader>gc", function()
  utils.run_command_in_term("git-pr-create", true)
end, { desc = "[G]it PR [C]reate" })

vim.keymap.set("n", "<leader>ge", function()
  utils.run_command_in_term("git-pr-edit", true)
end, { desc = "[G]it PR [E]dit" })

vim.keymap.set("n", "<leader>gu", function()
  local obj = vim.system({ "git-get-base-branch" }):wait()
  if obj.code ~= 0 then
    utils.print_err(vim.fn.trim(obj.stderr))
    return
  end
  local base_branch = vim.fn.trim(obj.stdout)

  utils.print("Rebasing worktree with " .. base_branch .. "...")
  obj = vim.system({ "gitw-rebase" }):wait()
  if obj.code ~= 0 then
    utils.print_err(vim.fn.trim(obj.stderr))
    return
  end
  utils.print("Rebased worktree with " .. base_branch .. "...")
end, { desc = "[G]it Rebase/[U]pdate With Base Branch" })

vim.keymap.set("n", "<leader>gvp", function()
  utils.print("Opening pull request in browser...")
  local obj = vim.system({ "gh", "pr", "view", "--web" }):wait()
  if obj.code ~= 0 then
    utils.print_err(vim.fn.trim(obj.stderr))
    return
  end
end, { desc = "[G]it [V]iew [P]r" })

vim.keymap.set("n", "<leader>gvb", function()
  utils.print("Opening branch in browser...")
  local obj = vim.system({ "git", "branch", "--show-current" }):wait()
  if obj.code ~= 0 then
    utils.print_err(vim.fn.trim(obj.stderr))
    return
  end
  obj = vim.system({ "gh", "browse", "-b", vim.fn.trim(obj.stdout) }):wait()
  if obj.code ~= 0 then
    utils.print_err(vim.fn.trim(obj.stderr))
    return
  end
end, { desc = "[G]it [V]iew [B]ranch" })

vim.keymap.set("n", "<leader>gvr", function()
  utils.print("Opening repository in browser...")
  local obj = vim.system({ "gh", "browse" }):wait()
  if obj.code ~= 0 then
    utils.print_err(vim.fn.trim(obj.stderr))
    return
  end
end, { desc = "[G]it [V]iew [R]epo" })

-- Select custom command to run from a visual prompt
vim.keymap.set("n", "<leader>p", function()
  local function get_ticket_url()
    local ticket_number = vim.fn.trim(vim.fn.system("get-ticket-number"))
    if vim.v.shell_error ~= 0 then
      utils.print_err(ticket_number)
      return nil
    end

    local base_url = vim.fn.expand("$BASE_TICKETS_URL")
    if base_url == "$BASE_TICKETS_URL" then
      utils.print_err("BASE_TICKETS_URL environment variable is not set!")
      return nil
    end

    return base_url .. ticket_number
  end

  local num_commands = 0
  local command_name = function(name)
    num_commands = num_commands + 1
    if num_commands < 10 then
      return "0" .. num_commands .. ". " .. name
    end
    return num_commands .. ". " .. name
  end

  local commands = {}
  local cmd = utils.get_project_linting_cmd()
  if cmd ~= nil then
    commands[command_name("[Project] Run linters")] = function()
      utils.run_command_in_term(table.concat(cmd, " "))
    end
  end

  commands[command_name("[Terminal] Open terminal in current buffer directory")] = function()
    local cur_dur = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h")
    cmd = { "tmux", "new-window", "-c", cur_dur }
    utils.print(table.concat(cmd, " "))
    local obj = vim.system(cmd):wait()
    if obj.code ~= 0 then
      utils.print_err(vim.fn.trim(obj.stderr))
    end
  end

  commands[command_name("[Project] Run mypy")] = function()
    utils.print("Running mypy...")
    vim.system(
      utils.dmypy_args(true), {}, function(obj)
        vim.schedule(function()
          if obj.code > 1 then
            utils.print_err(vim.fn.trim(obj.stderr))
            return
          end
          utils.print("Finished running mypy")
          utils.parse_dmypy_output(obj.stdout)
        end)
      end)
  end

  commands[command_name("[Github] Yank PR to clipboard")] = function()
    vim.system({ "gh", "pr", "view", "--json", "url", "--jq", ".url" }, { text = true }, function(obj)
      vim.schedule(function()
        if obj.code ~= 0 then
          utils.print_err(vim.fn.trim(obj.stderr))
          return
        end

        local url = vim.fn.trim(obj.stdout)
        local cb_opts = vim.opt.clipboard:get()
        if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", url) end
        if vim.tbl_contains(cb_opts, "unnamedplus") then
          vim.fn.setreg("+", url)
        end
        vim.fn.setreg("", url)
        utils.print("Copied " .. url .. " to clipboard")
      end)
    end)
  end

  commands[command_name("[Ticket] Open in browser")] = function()
    local ticket_url = get_ticket_url()
    if ticket_url == nil then
      return
    end

    vim.ui.open(ticket_url)
  end
  commands[command_name("[Ticket] Yank to clipboard")] = function()
    local ticket_url = get_ticket_url()
    if ticket_url == nil then
      return
    end

    local cb_opts = vim.opt.clipboard:get()
    if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", ticket_url) end
    if vim.tbl_contains(cb_opts, "unnamedplus") then
      vim.fn.setreg("+", ticket_url)
    end
    vim.fn.setreg("", ticket_url)
    utils.print("Copied " .. ticket_url .. " to clipboard")
  end
  commands[command_name("[Mini] Save session")] = function()
    ---@diagnostic disable-next-line: undefined-global
    MiniSessions.write("Session.vim")
  end
  commands[command_name("[File] Make current file executable")] = function()
    local obj = vim.system({ "chmod", "+x", vim.fn.expand("%") }):wait()
    if obj.code ~= 0 then
      utils.print_err(vim.fn.trim(obj.stderr))
      return
    end
    utils.print("File marked as executable")
  end
  commands[command_name("[File] Yank current file path")] = function()
    local path = vim.fn.expand("%")
    local cb_opts = vim.opt.clipboard:get()
    if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", path) end
    if vim.tbl_contains(cb_opts, "unnamedplus") then
      vim.fn.setreg("+", path)
    end
    vim.fn.setreg("", path)
    utils.print("Copied " .. path .. " to clipboard")
  end
  commands[command_name("[Journal] Create new entry")] = function()
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
        local file_week = tonumber(week)
        if file_week < 10 then
          ---@diagnostic disable-next-line: cast-local-type
          file_week = "0" .. file_week
        end
        local journal_entry = workspace .. "/notes/journal/" .. year .. "/week-" .. file_week .. ".md"
        local obj = vim.system({ "create-journal-entry", template, journal_entry, year, week }, { text = true }):wait()
        if obj.code ~= 0 then
          utils.print_err(vim.fn.trim(obj.stderr))
          return
        end
        vim.cmd(":e " .. journal_entry)
      end)
    end)
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

vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", {
  desc = "Fix last spelling mistake whilst persisting the cursor position",
})
