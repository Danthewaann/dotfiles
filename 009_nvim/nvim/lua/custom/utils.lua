M = {}

local python_venv = nil

-- From: https://github.com/nvim-telescope/telescope.nvim/issues/1923#issuecomment-1122642431
M.get_visual_selection = function()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

-- From: https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
M.get_poetry_venv_executable_path = function(exe, workspace)
  workspace = workspace or "."

  -- Check if the executable exists in the .venv/bin directory
  -- (as this is much quicker than running the poetry command)
  local venv_exe = table.concat({ workspace, ".venv", "bin", exe }, "/")
  if M.file_exists(venv_exe) then
    return venv_exe
  end

  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return table.concat({ vim.env.VIRTUAL_ENV, "bin", exe }, "/")
  end

  -- Find and use virtualenv via poetry in workspace directory.
  if M.file_exists(table.concat({ workspace, "poetry.lock" }, "/")) then
    if python_venv == nil then
      local obj = vim.system({ "poetry", "env", "info", "-p" }):wait()
      python_venv = vim.fn.trim(obj.stdout)
    end
    venv_exe = table.concat({ python_venv, "bin", exe }, "/")
    if M.file_exists(venv_exe) then
      return venv_exe
    end
  end

  -- Fallback to the provided exe
  return exe
end

M.file_exists = function(filename)
  return vim.uv.fs_stat(filename)
end

M.get_project_linting_cmd = function()
  local cmd = {}
  local file = ""

  if M.file_exists("poetry.lock") then
    cmd = { "poetry", "run" }
  else
    return nil
  end

  if M.file_exists("scripts/lint.sh") then
    file = "scripts/lint.sh"
  else
    return nil
  end

  cmd[#cmd + 1] = file
  return cmd
end

M.run_command_in_term = function(args, use_tmux)
  if use_tmux then
    vim.cmd(":Tmux " .. args)
  else
    vim.fn["test#strategy#neovim_sticky"](args)
  end
end

M.print = function(msg)
  vim.notify(msg, vim.log.levels.INFO)
end

M.print_err = function(err)
  vim.notify(err, vim.log.levels.ERROR)
end

M.parse_dmypy_output = function(output)
  -- From: https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/mypy.lua
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
        text = message,
      })
    end
  end

  vim.fn.setqflist({}, " ", { title = "Mypy errors", items = list })
  vim.cmd(":botright copen | silent! cc 1")
end

M.dmypy_args = function(include_cmd)
  local args = {}
  if include_cmd then
    table.insert(args, M.get_poetry_venv_executable_path("dmypy"))
  end

  table.insert(args, "run")
  table.insert(args, "--timeout")
  table.insert(args, "50000")
  table.insert(args, "--")
  table.insert(args, ".")
  table.insert(args, "--show-column-numbers")
  table.insert(args, "--show-error-end")
  table.insert(args, "--show-error-codes")
  table.insert(args, "--hide-error-context")
  table.insert(args, "--no-color-output")
  table.insert(args, "--no-error-summary")
  table.insert(args, "--no-pretty")

  -- This is a table of error codes I ignore as I let basedpyright handle them instead
  local error_codes = { "assignment", "name-defined", "call-arg" }
  for _, code in ipairs(error_codes) do
    table.insert(args, "--disable-error-code")
    table.insert(args, code)
  end

  return args
end

-- filetypes to ignore for plugins
M.ignore_filetypes = {
  "NeogitStatus",
  "DiffviewFileHistory",
  "DiffviewFiles",
  "neotest-summary",
  "qf",
  "git",
  "dbui",
  "ministarter",
  "diff",
  "gitcommit",
  "list",
  "help",
  "man",
  "octo_panel",
  "dbout",
  "oil",
  "VimspectorPrompt",
  "vimspector-disassembly",
}

return M
