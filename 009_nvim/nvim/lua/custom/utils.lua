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

M.get_highlight = function(name)
  return vim.api.nvim_get_hl(0, { name = name })
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
    vim.api.nvim_echo({ { "Not supported", "ErrorMsg" } }, true, {})
    return nil
  end

  if M.file_exists("scripts/lint.sh") then
    file = "scripts/lint.sh"
  else
    vim.api.nvim_echo({ { "Not supported", "ErrorMsg" } }, true, {})
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

-- Map of filetypes to foldmethod
M.filetype_folds = { go = "lsp" }

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
}

return M
