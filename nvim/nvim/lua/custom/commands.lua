local utils = require("custom.utils")

---@param cmd string
---@param action function
---@param opts table
---@param abbrev string | false | nil
local command = function(cmd, action, opts, abbrev)
  vim.api.nvim_create_user_command(cmd, action, opts)
  if abbrev == false then
    return
  end
  abbrev = abbrev or cmd:lower()
  utils.cabbrev(abbrev, cmd)
end

command("Mypy", function()
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

  utils.print("Running mypy\n\nCOMMAND:\n" .. table.concat(cmd, " "))
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

command("Ruff", function()
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
  utils.print("Running ruff\n\nCOMMAND:\n" .. table.concat(cmd, " "))
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

command("YankCommits", function(args)
  local count = 1
  if #args.args > 0 then
    count = tonumber(args.args) or 1
  end
  local cmd = { "sh", "-c", "git log --oneline | head -n " .. count .. " | tac | awk '{print NR \".\", $0}'" }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    utils.handle_system_err("yank commits", cmd, obj)
  end
  local cb_opts = vim.opt.clipboard:get()
  if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", obj.stdout) end
  if vim.tbl_contains(cb_opts, "unnamedplus") then
    vim.fn.setreg("+", obj.stdout)
  end
  vim.fn.setreg("", obj.stdout)
  utils.print("Copied last " .. count .. " commits to clipboard")
end, { desc = "Yank commits to clipboard", nargs = "?" }, "yc")

command("DeleteBuffers", function()
  vim.cmd("%bd|e#|bd#")
end, { desc = "Delete all other buffers" }, "del")

command("TmuxTerm", function()
  local cur_dur = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h")
  local cmd = { "tmux", "new-window", "-c", cur_dur }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    utils.handle_system_err("term", cmd, obj)
  end
end, { desc = "Open terminal in current buffer directory" }, "tt")


-- Git/GitHub commands
local gitw_script = function(oper)
  ---@param args vim.api.keyset.create_user_command.command_args
  return function(args)
    local cmd = { ("gitw-%s"):format(oper) }
    if args.args ~= "" then
      table.insert(cmd, args.args)
    end
    local name = table.concat(cmd, " ")
    utils.print(("Running %s..."):format(name))
    vim.system(cmd, { text = true }, function(out)
      vim.schedule(function()
        if out.code ~= 0 then
          utils.handle_system_err(name, cmd, out)
          return
        end
        utils.print(("%s was successful"):format(name))
      end)
    end)
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

command("Ga", gitw_script("add"), { nargs = 1, desc = "Git add branch and checkout to worktree" })
command("Gu", gitw_script("update"), { desc = "Git update current branch with origin" })
command("Gr", gitw_script("rebase"), { desc = "Git rebase current branch with origin base" })
command("Gm", gitw_script("merge"), { desc = "Git merge current branch with origin base" })
command("Prc", git_pr_script("create"), { desc = "GitHub create PR" })
command("Pre", git_pr_script("edit"), { desc = "GitHub edit PR" })
command("Rv", github_view("repo"), { desc = "GitHub view current repo in browser" })
command("Rc", copy_to_clipboard("git-repo"), { desc = "GitHub copy current repo to clipboard" })
command("Pv", github_view("pr"), { desc = "GitHub view current PR in browser" })
command("Pc", copy_to_clipboard("git-pr"), { desc = "GitHub copy current PR to clipboard" })
command("Bv", function()
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
end, { desc = "GitHub view current branch in browser" })
command("Bc", copy_to_clipboard("git-branch"), { desc = "GitHub copy current branch to clipboard" })
command("Tv", function()
  local cmd = { "ticket-open" }
  vim.system(cmd, { text = true }, function(out)
    vim.schedule(function()
      if out.code ~= 0 then
        utils.handle_system_err(table.concat(cmd, " "), cmd, out)
      end
    end)
  end)
end, { desc = "GitHub view current ticket in browser" })
command("Tc", copy_to_clipboard("ticket"), { desc = "GitHub copy current ticket to clipboard" })
command("Gap", function()
  local cmd = { "git-apply-patch" }
  local obj = vim.system(cmd):wait()
  if obj.code ~= 0 then
    utils.handle_system_err(table.concat(cmd, " "), cmd, obj)
  end
end, { desc = "Git apply patch from clipboard" })
