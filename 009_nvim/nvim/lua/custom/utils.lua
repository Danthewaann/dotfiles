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

M.trim = function(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

M.run_command_in_term = function(args, use_tmux)
  if use_tmux then
    vim.cmd(":Tmux " .. args)
  else
    require("toggleterm").exec(args, nil, nil, nil, nil, nil, false, true)
    M.schedule_start_insert()
  end
end

M.schedule_start_insert = function()
  -- Go back into insert mode to follow the command output
  vim.schedule(function()
    vim.cmd(":startinsert!")
  end)
end

M.run_job = function(command, args, success_message, callback)
  args = args or {}
  if success_message == nil then
    success_message = "Success!"
  end
  local job = require("plenary.job")
  local j = job:new({ command = command, args = args })
  j:add_on_exit_callback(function()
    local output = j:stderr_result()
    if j.code ~= 0 then
      local output_str = M.trim(table.concat(output, "\n"))
      vim.schedule(function()
        M.print_err(output_str)
      end)
    elseif success_message ~= false then
      vim.schedule(function()
        M.print(success_message)
      end)
    end
  end)
  if callback ~= nil then
    j:add_on_exit_callback(callback)
  end
  j:start()
end

M.print = function(msg)
  vim.notify(msg, vim.log.levels.INFO)
end

M.print_err = function(err)
  vim.notify(err, vim.log.levels.ERROR)
end

-- filetypes to ignore for plugins
M.ignore_filetypes = {
  "NeogitStatus",
  "qf",
  "git",
  "dbui",
  "diff",
  "gitcommit",
  "list",
  "help",
  "man",
  "spectre_panel",
  "dbout",
  "oil",
  "VimspectorPrompt",
  "vimspector-disassembly",
}

return M
