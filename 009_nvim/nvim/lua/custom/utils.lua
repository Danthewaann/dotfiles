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
M.get_poetry_venv_executable_path = function(exe, check_poetry, workspace)
  check_poetry = check_poetry or false
  workspace = workspace or nil

  local lsp_utils = require("lspconfig/util")

  -- Check if the executable exists in the .venv/bin directory
  -- (as this is much quicker than running the poetry command)
  local venv_exe = lsp_utils.path.join(workspace, ".venv", "bin", exe)
  if M.file_exists(venv_exe) then
    return venv_exe
  end

  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return lsp_utils.path.join(vim.env.VIRTUAL_ENV, "bin", exe)
  end

  -- Find and use virtualenv via poetry in workspace directory.
  if check_poetry and M.file_exists(lsp_utils.path.join(workspace, "poetry.lock")) then
    if python_venv == nil then
      python_venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
    end
    venv_exe = lsp_utils.path.join(python_venv, "bin", exe)
    if M.file_exists(venv_exe) then
      return venv_exe
    end
  end

  -- Fallback to the provided exe
  return exe
end

M.file_exists = function(filename)
  return vim.loop.fs_stat(filename)
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

M.get_ticket_number = function()
  return vim.fn.trim(vim.fn.system("get-ticket-number"))
end

M.replace_ticket_number = function()
  local ticket_number = M.get_ticket_number()
  if vim.v.shell_error ~= 0 then
    M.print_err(ticket_number)
    return
  end

  local ok, _ = pcall(vim.cmd, "%s/TICKET_NUMBER/" .. ticket_number .. "/g")
  if not ok then
    M.print_err("TICKET_NUMBER pattern not found in file!")
    return
  end

  vim.cmd("normal! ``")
end

M.trim = function(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

M.run_job = function(command, args, success_message)
  args = args or {}
  success_message = success_message or "Success!"
  local job = require("plenary.job")
  local j = job:new({ command = command, args = args })
  j:add_on_exit_callback(function()
    local output = j:stderr_result()
    if j.code ~= 0 then
      output = M.trim(table.concat(output, "\n"))
      M.print_err(output)
    else
      M.print(success_message)
    end
  end)
  j:start()
end

M.print = function(msg)
  require("noice").notify(msg, vim.log.levels.INFO)
end

M.print_err = function(err)
  require("noice").notify(err, vim.log.levels.ERROR)
end

-- filetypes to ignore for plugins
M.ignore_filetypes = {
  "qf",
  "git",
  "fugitive",
  "fugitiveblame",
  "dbui",
  "undotree",
  "diff",
  "gitcommit",
  "GV",
  "list",
  "help",
  "man",
  "spectre_panel",
  "dbout",
  "DiffviewFiles",
  "DiffviewFileHistory",
  "oil",
  "aerial",
  "Trouble",
  "Octo",
  "octo_panel",
  "VimspectorPrompt",
  "vimspector-disassembly",
  "toggleterm",
  "starter",
}

return M
