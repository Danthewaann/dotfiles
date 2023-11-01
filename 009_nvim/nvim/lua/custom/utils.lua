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
  local util = require("lspconfig/util")
  local path = util.path

  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- Find and use virtualenv via poetry in workspace directory.
  local match = vim.fn.glob(path.join(workspace, "poetry.lock"))
  if match ~= "" then
    local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
    return path.join(venv, "bin", "python")
  end

  -- Fallback to system Python.
  return exepath("python3") or exepath("python") or "python"
end

M.file_exists = function(filename)
  return vim.fn.filereadable(filename)
end

return M
