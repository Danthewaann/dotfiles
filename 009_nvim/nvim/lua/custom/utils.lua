M = {}

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

M.unfold = function()
  vim.defer_fn(function()
    pcall(vim.cmd.normal, "zvzczOzz")
  end, 100)
end

-- From: https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
M.get_python_path = function(workspace)
  local exe = M.get_poetry_venv_executable_path("python", workspace)

  if exe ~= nil then
    return exe
  end

  -- Fallback to system Python.
  return "python"
end

M.get_ipython_path = function(workspace)
  local exe = M.get_poetry_venv_executable_path("ipython", workspace)

  if exe ~= nil then
    return exe
  end

  -- Fallback to system IPython.
  return "ipython"
end

M.get_poetry_venv_executable_path = function(exe, workspace)
  local util = require("lspconfig/util")
  local path = util.path

  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", exe)
  end

  -- Find and use virtualenv via poetry in workspace directory.
  local match = vim.fn.glob(path.join(workspace, "poetry.lock"))
  if match ~= "" then
    local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
    return path.join(venv, "bin", exe)
  end

  return nil
end

M.file_exists = function(filename)
  return vim.fn.filereadable(filename)
end

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
-- From: https://gist.github.com/hashmal/874792
M.tprint = function(tbl, indent)
  if not indent then
    indent = 0
  end
  for k, v in pairs(tbl) do
    local formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      M.tprint(v, indent + 1)
    else
      print(formatting .. tostring(v))
    end
  end
end

M.merge_tables = function(table_1, table_2)
  for k, v in pairs(table_2) do table_1[k] = v end
  return table_1
end

M.run_cmd_in_term = function(position, cmd)
  vim.cmd(":" .. position .. " new")
  vim.fn.termopen(cmd)
  vim.cmd("keepalt")
end

M.run_linting = function()
  local cmd = {}
  local file = ""

  if vim.fn.filereadable("poetry.lock") == 1 then
    cmd = { "poetry", "run" }
  else
    vim.api.nvim_echo({ { "Not supported", "ErrorMsg" } }, true, {})
    return
  end

  if vim.fn.filereadable("scripts/lint.sh") == 1 then
    file = "scripts/lint.sh"
  else
    vim.api.nvim_echo({ { "Not supported", "ErrorMsg" } }, true, {})
    return
  end

  cmd[#cmd + 1] = file
  M.run_cmd_in_term("vertical", table.concat(cmd, " "))
end

M.get_ticket_number = function()
  return vim.fn.trim(vim.fn.system("get-ticket-number"))
end

M.replace_ticket_number = function()
  local ticket_number = M.get_ticket_number()
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { ticket_number, "ErrorMsg" } }, true, {})
    return
  end

  local ok, _ = pcall(vim.cmd, ":%s/TICKET_NUMBER/" .. ticket_number .. "/g")
  if not ok then
    vim.api.nvim_echo({ { "TICKET_NUMBER pattern not found in file!", "ErrorMsg" } }, true, {})
  end
end

-- Check if the provided terminal is running.
-- From: https://stackoverflow.com/a/59585734
M.term_is_running = function(buffer)
  local buf_type = vim.fn.getbufvar(buffer, "&buftype")
  if buf_type ~= "terminal" then
    return false
  end

  local job_status = vim.fn.jobwait({ vim.fn.getbufvar(buffer, "&channel") }, 0)
  if job_status[1] == -1 then
    return true
  end

  return false
end

return M
