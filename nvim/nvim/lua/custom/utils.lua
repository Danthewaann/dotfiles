local module = {}

local python_venv = nil

-- From: https://github.com/nvim-telescope/telescope.nvim/issues/1923#issuecomment-1122642431
module.get_visual_selection = function()
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
module.get_venv_executable_path = function(exe, workspace)
  workspace = workspace or "."

  -- Check if the executable exists in the .venv/bin directory
  -- (as this is much quicker than running the poetry command)
  local venv_exe = table.concat({ workspace, ".venv", "bin", exe }, "/")
  if module.file_exists(venv_exe) then
    return venv_exe
  end

  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return table.concat({ vim.env.VIRTUAL_ENV, "bin", exe }, "/")
  end

  -- Fallback to the provided exe
  return exe
end

module.file_exists = function(filename)
  return vim.uv.fs_stat(filename)
end

module.get_project_linting_cmd = function()
  local cmd = {}
  local file = ""

  if module.file_exists("poetry.lock") then
    cmd = { "poetry", "run" }
  else
    return nil
  end

  if module.file_exists("scripts/lint.sh") then
    file = "scripts/lint.sh"
  else
    return nil
  end

  cmd[#cmd + 1] = file
  return cmd
end

module.run_command_in_term = function(args, use_tmux)
  if use_tmux then
    vim.cmd(":Tmux " .. args)
  else
    vim.fn["test#strategy#neovim_sticky"](args)
  end
end

module.print = function(msg)
  vim.notify(msg, vim.log.levels.INFO)
end

module.print_err = function(err)
  vim.notify(err, vim.log.levels.ERROR)
end

module.parse_ruff_output = function(output)
  -- From: https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/ruff.lua
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
  vim.cmd(":botright copen | silent! cc 1")
end

module.parse_mypy_output = function(output)
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
        source = "mypy"
      })
    end
  end

  vim.fn.setqflist({}, " ", { title = "Mypy errors", items = list })
  vim.cmd(":botright copen | silent! cc 1")
end

module.mypy_args = function(include_cmd)
  local args = {}
  if include_cmd then
    table.insert(args, module.get_venv_executable_path("mypy"))
  end

  table.insert(args, "--show-column-numbers")
  table.insert(args, "--show-error-end")
  table.insert(args, "--show-error-codes")
  table.insert(args, "--hide-error-context")
  table.insert(args, "--no-color-output")
  table.insert(args, "--no-error-summary")
  table.insert(args, "--no-pretty")
  table.insert(args, ".")

  return args
end

module.dmypy_args = function(include_cmd)
  local args = {}
  if include_cmd then
    table.insert(args, module.get_venv_executable_path("dmypy"))
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

  return args
end

module.get_cursor_position = function(path)
  local filename_modifier = vim.g["test#filename_modifier"] or ":."
  local position = {
    file = vim.fn.fnamemodify(path, filename_modifier),
    line = path == vim.fn.expand("%") and vim.fn.line(".") or 1,
    col = path == vim.fn.expand("%") and vim.fn.col(".") or 1,
  }
  return position
end

-- filetypes to ignore for plugins
module.ignore_filetypes = {
  "NeogitStatus",
  "DiffviewFileHistory",
  "DiffviewFiles",
  "neotest-summary",
  "qf",
  "git",
  "dashboard",
  "dbui",
  "diff",
  "gitcommit",
  "list",
  "help",
  "man",
  "octo_panel",
  "dbout",
  "oil"
}

return module
