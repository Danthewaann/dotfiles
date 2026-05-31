local module = {}

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

module.print = function(msg)
  vim.notify(msg, vim.log.levels.INFO)
end

module.print_err = function(err)
  vim.notify(err, vim.log.levels.ERROR)
end

module.get_terminal_buffer = function()
  local terminal_buf = nil

  -- Iterate through all buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- Check if the buffer is a terminal and has the variable `_test_vim_neovim_sticky`
    if vim.bo[buf].buftype == "terminal" and vim.b[buf]._test_vim_neovim_sticky ~= nil then
      terminal_buf = buf
      break
    end
  end

  return terminal_buf
end

module.generate_pytest_options = function(mode)
  local options = {}
  -- If pytest-xdist is installed in the current python project, use it when running the suite strategy,
  -- and disable it when running the nearest or file test strategies
  local xdist_installed = vim.system({ "grep", "pytest-xdist", "pyproject.toml" }, { text = true }):wait()
  if mode == "vim-test" then
    options = { nearest = "-vv" }
    if xdist_installed.code == 0 then
      options.nearest = options.nearest .. " -n 0"
      options.file = "-n 0 -vv"
      options.suite = "-n auto"
    end
  elseif mode == "dap" then
    if xdist_installed.code == 0 then
      options = {
        config = function(conf)
          table.insert(conf.args, "-n")
          table.insert(conf.args, "0")
          return conf
        end
      }
    else
      options = { nearest = "-vv" }
    end
  end

  return options
end

return module
