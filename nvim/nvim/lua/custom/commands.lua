local utils = require("custom.utils")

utils.create_command("Mypy", function()
  local cmd = {
    utils.get_venv_executable_path("mypy"),
    "--show-column-numbers",
    "--show-error-end",
    "--show-error-codes",
    "--hide-error-context",
    "--no-color-output",
    "--no-error-summary",
    "--no-pretty",
  }
  for _, option in ipairs(utils.generate_mypy_options()) do
    table.insert(cmd, option)
  end
  table.insert(cmd, ".")

  utils.print("Running mypy...")
  vim.system(cmd, {}, function(obj)
    vim.schedule(function()
      if obj.code > 1 then
        utils.handle_system_err("mypy", cmd, obj)
        return
      end

      -- From: https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/mypy.lua
      local output = obj.stdout
      local pattern = "([^:]+):(%d+):(%d+):(%d+):(%d+): (%a+): (.*) %[(%a[%a-]+)%]"
      local severities = {
        error = "E",
        warning = "W",
        note = "N",
      }

      local list = {}
      for line in vim.gsplit(output, "\n", { plain = true }) do
        local file, lnum, col, end_lnum, end_col, severity, message, code = line:match(pattern)
        if file then
          table.insert(list, {
            filename = file,
            lnum = lnum,
            col = col,
            end_lnum = end_lnum,
            end_col = end_col,
            nr = code,
            type = severities[severity],
            text = message .. " # type: ignore [" .. code .. "]",
            source = "mypy"
          })
        end
      end

      vim.fn.setqflist({}, " ", { title = "Mypy errors", items = list })
      if #list > 0 then
        utils.print_err("Mypy found " .. #list .. " error(s)")
      else
        utils.print("Mypy finished with no errors")
      end
    end)
  end)
end, { desc = "Run Mypy and populate quickfix list with errors" })

utils.create_command("Ruff", function()
  local cmd = {
    utils.get_venv_executable_path("ruff"),
    "check",
    "--force-exclude",
    "--quiet",
    "--no-fix",
    "--output-format",
    "json",
    ".",
  }
  utils.print("Running ruff...")
  vim.system(cmd, {},
    function(obj)
      vim.schedule(function()
        if obj.code > 1 then
          utils.handle_system_err("ruff", cmd, obj)
          return
        end

        -- From: https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/ruff.lua
        local output = obj.stdout
        local severities = {
          ["F821"] = "E", -- undefined name `name`
          ["E902"] = "E", -- `IOError`
          ["E999"] = "E", -- `SyntaxError`
        }

        local list = {}
        local results = vim.json.decode(output)
        for _, result in ipairs(results or {}) do
          local diagnostic = {
            filename = result.filename,
            lnum = result.location.row,
            col = result.location.column,
            end_lnum = result.end_location.row,
            end_col = result.end_location.column,
            nr = result.code,
            type = severities[result.code] or "W",
            text = result.message,
            source = "ruff"
          }
          table.insert(list, diagnostic)
        end

        vim.fn.setqflist({}, " ", { title = "Ruff errors", items = list })
        if #list > 0 then
          utils.print_err("Ruff found " .. #list .. " error(s)")
        else
          utils.print("Ruff finished with no errors")
        end
      end)
    end)
end, { desc = "Run Ruff and populate quickfix list with errors" })

utils.create_command("YankCommits", function(args)
  local count = 1
  if #args.args > 0 then
    count = tonumber(args.args) or 1
  end
  local cmd = { "sh", "-c", "git log --oneline | head -n " .. count .. " | tac | awk '{print NR \".\", $0}'" }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    utils.handle_system_err("yank commits", cmd, obj)
  end
  utils.copy_to_clipboard(obj.stdout)
  utils.print("Copied last " .. count .. " commits to clipboard")
end, { desc = "Yank commits to clipboard", nargs = "?" }, "yc")

utils.create_command("DeleteBuffers", function()
  vim.cmd("%bd|e#|bd#")
end, { desc = "Delete all other buffers" }, "del")

utils.create_command("TmuxTerm", function()
  local cur_dur = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h")
  local cmd = { "tmux", "new-window", "-c", cur_dur }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    utils.handle_system_err("term", cmd, obj)
  end
end, { desc = "Open terminal in current buffer directory" }, "tt")

utils.create_command("GotoFile", function(args)
  utils.jump_to_file({ file = args.args })
end, { nargs = 1, desc = "Go to file (supports pytest nodeids)" }, "gf")

-- Git/GitHub commands
local git_worktree_script = function(oper)
  ---@param args vim.api.keyset.create_user_command.command_args
  return function(args)
    local cmd = { ("git-worktree-%s"):format(oper) }
    if args.args ~= "" then
      table.insert(cmd, args.args)
    end
    local name = table.concat(cmd, " ")
    print(("Running %s..."):format(name))
    utils.stream_command(cmd)
  end
end

local git_pr_script = function(oper)
  return function()
    local cmd = { "tmux", "split-window", "-h", "-c", "#{pane_current_path}" }
    vim.system(cmd, { text = true }, function(out)
      vim.schedule(function()
        if out.code ~= 0 then
          utils.handle_system_err(table.concat(cmd, " "), cmd, out)
          return
        end

        cmd = { "tmux", "send-keys", ("git-pr-%s"):format(oper), "ENTER" }
        vim.system(cmd, { text = true }, function(out2)
          vim.schedule(function()
            if out2.code ~= 0 then
              utils.handle_system_err(table.concat(cmd, " "), cmd, out2)
              return
            end
          end)
        end)
      end)
    end)
  end
end

local github_view = function(oper)
  return function()
    local cmd = { "gh", oper, "view", "--web" }
    vim.system(cmd, { text = true }, function(out)
      vim.schedule(function()
        if out.code ~= 0 then
          utils.handle_system_err(table.concat(cmd, " "), cmd, out)
          return
        end
      end)
    end)
  end
end

local copy_to_clipboard = function(oper)
  return function()
    local cmd = { ("%s-copy"):format(oper) }
    vim.system(cmd, { text = true }, function(out)
      vim.schedule(function()
        if out.code ~= 0 then
          utils.handle_system_err(table.concat(cmd, " "), cmd, out)
          return
        end
        utils.print(("Copied %s to clipboard"):format(vim.fn.trim(out.stdout)))
      end)
    end)
  end
end

utils.create_command("GitWorktreeAdd", git_worktree_script("add"),
  { nargs = 1, desc = "Git add branch and checkout to worktree" }, "gwa")
utils.create_command("GitWorktreeUpdate", git_worktree_script("update"),
  { desc = "Git update current branch with origin" }, "gwu")
utils.create_command("GitWorktreeRebase", git_worktree_script("rebase"),
  { nargs = "?", desc = "Git rebase current branch with origin base" }, "gwr"
)
utils.create_command("GitWorktreeMerge", git_worktree_script("merge"),
  { nargs = "?", desc = "Git merge current branch with origin base" }, "gwm")
utils.create_command("GitWorktreeDelete", git_worktree_script("delete"),
  { nargs = "?", desc = "Git delete worktrees in current repo, or just the provided worktree" }, "gwd")
utils.create_command("GitPRCreate", git_pr_script("create"), { desc = "GitHub create PR" }, "prc")
utils.create_command("GitPREdit", git_pr_script("edit"), { desc = "GitHub edit PR" }, "pre")
utils.create_command("GitRepoView", github_view("repo"), { desc = "GitHub view current repo in browser" }, "rv")
utils.create_command(
  "GitRepoCopy",
  copy_to_clipboard("git-repo"),
  { desc = "GitHub copy current repo to clipboard" },
  "rc"
)
utils.create_command("GitPRView", github_view("pr"), { desc = "GitHub view current PR in browser" }, "pv")
utils.create_command("GitPRCopy", copy_to_clipboard("git-pr"), { desc = "GitHub copy current PR to clipboard" }, "pc")
utils.create_command("GitBranchView", function()
  local cmd = { "git", "branch", "--show-current" }
  vim.system(cmd, { text = true }, function(out)
    vim.schedule(function()
      if out.code ~= 0 then
        utils.handle_system_err(table.concat(cmd, " "), cmd, out)
        return
      end
      cmd = { "gh", "repo", "view", "--web", "--branch", vim.fn.trim(out.stdout) }
      vim.system(cmd, { text = true }, function(out2)
        vim.schedule(function()
          if out2.code ~= 0 then
            utils.handle_system_err(table.concat(cmd, " "), cmd, out2)
          end
        end)
      end)
    end)
  end)
end, { desc = "GitHub view current branch in browser" }, "bv")
utils.create_command("GitBranchCopy", copy_to_clipboard("git-branch"),
  { desc = "GitHub copy current branch to clipboard" }, "bc")
utils.create_command("TicketView", function()
  local cmd = { "ticket-open" }
  vim.system(cmd, { text = true }, function(out)
    vim.schedule(function()
      if out.code ~= 0 then
        utils.handle_system_err(table.concat(cmd, " "), cmd, out)
      end
    end)
  end)
end, { desc = "GitHub view current ticket in browser" }, "tv")
utils.create_command(
  "TicketCopy",
  copy_to_clipboard("ticket"),
  { desc = "GitHub copy current ticket to clipboard" },
  "tc"
)
utils.create_command("GitApplyPatch", function()
  local cmd = { "git-apply-patch" }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    utils.handle_system_err(table.concat(cmd, " "), cmd, obj)
  end
end, { desc = "Git apply patch from clipboard" }, "gap")
utils.create_command("GitConflicts", function()
  local cmd = { "git", "jump", "--stdout", "merge" }
  vim.system(cmd, {}, function(obj)
    vim.schedule(function()
      if obj.code > 1 then
        utils.handle_system_err("git jump", cmd, obj)
        return
      end
      local qf_entries = {}
      for line in obj.stdout:gmatch("[^\r\n]+") do
        local filename, lnum, text = line:match("([^:]+):(%d+):%s*(.+)")
        if filename and lnum and text then
          table.insert(qf_entries, {
            filename = filename,
            lnum = tonumber(lnum),
            col = 0,
            text = text,
          })
        end
      end

      if #qf_entries == 0 then
        utils.print("No git conflicts found!")
        return
      end
      vim.fn.setqflist({}, " ", { title = "Git conflicts", items = qf_entries })
      vim.cmd("copen")
    end)
  end)
end, { desc = "Show Git Conflicts" }, "gx")

-- Diff commands
utils.create_command("GitDiffStats", function()
  local cmd = { "git-get-base-branch" }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    utils.handle_system_err("get base branch", cmd, obj)
    return
  end
  local base_branch = vim.fn.trim(obj.stdout)

  cmd = { "git", "--no-pager", "diff", "--shortstat", ("%s..HEAD"):format(base_branch) }
  obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    utils.handle_system_err("get base branch", cmd, obj)
    return
  end
  local stat = vim.fn.trim(obj.stdout)

  utils.print(stat)
end, { desc = "Show diff stats with base branch" }, "gds")
utils.create_command("DiffFiles", function(args)
  local first = nil
  local second = nil

  -- If we haven't provided two buffers, then diff two buffers
  -- in the current tabpage if there is only two windows
  if #args.fargs == 0 then
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local valid_bufs = {}
    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "" then
        table.insert(valid_bufs, buf)
      end
    end
    if #valid_bufs == 2 then
      first = vim.api.nvim_buf_get_name(valid_bufs[1])
      second = vim.api.nvim_buf_get_name(valid_bufs[2])
    end
  else
    first = args.fargs[1]
    second = args.fargs[2]
  end

  if first and second then
    require("difftool").open(first, second)
  else
    utils.print_err("Can only diff with two buffers")
  end
end, { desc = "Show diff of two buffers", nargs = "?" }, "dt")
