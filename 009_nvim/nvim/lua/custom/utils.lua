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

M.unfold = function()
  vim.defer_fn(function()
    pcall(vim.cmd, "normal! zvzCzOzz")
  end, 100)
end

M.unfold_check = function()
  vim.defer_fn(function()
    local line_data = vim.api.nvim_win_get_cursor(0)    -- returns {row, col}
    local fold_closed = vim.fn.foldclosed(line_data[1]) -- -1 if no fold at line
    if fold_closed ~= -1 then                           -- fold exists (not -1)
      pcall(vim.cmd, "normal! zvzCzOzz")
    end
  end, 100)
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

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
-- From: https://gist.github.com/hashmal/874792
M.table_print = function(tbl, indent)
  if not indent then
    indent = 0
  end
  for k, v in pairs(tbl) do
    local formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      M.table_print(v, indent + 1)
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
  -- Save changes to the file
  vim.cmd.write()
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
M.filetype_folds = {
  python = "treesitter",
  go = "treesitter",
  lua = "treesitter",
  ruby = "indent",
  markdown = "treesitter",
  sh = "treesitter",
  yaml = "treesitter",
  javascript = "treesitter",
  make = "treesitter"
}

M.apply_folds = function(buf)
  local filetype = vim.fn.getbufvar(buf, "&filetype")
  if M.filetype_folds[filetype] then
    M.apply_folds_and_then_close_all_folds(buf, M.filetype_folds[filetype])
    return true
  end
  return false
end

-- Automatically close all folds when opening a file
-- From: https://github.com/kevinhwang91/nvim-ufo/issues/89#issuecomment-1286250241
-- And: https://github.com/kevinhwang91/nvim-ufo/issues/83#issuecomment-1259233578
M.apply_folds_and_then_close_all_folds = function(bufnr, providerName)
  require("async")(function()
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    -- make sure buffer is attached
    require("ufo").attach(bufnr)

    local apply_and_close = function(provider)
      local ok, ranges = pcall(await, require("ufo").getFolds(bufnr, provider))
      if ok and ranges then
        ok = require("ufo").applyFolds(bufnr, ranges)
        if ok then
          require("ufo").closeAllFolds()
          -- Load the saved view to apply saved folds
          pcall(vim.cmd, "silent! loadview")
        end
      end
      return ok
    end

    if not apply_and_close(providerName) then
      -- fallback to indent folding
      apply_and_close("indent")
    end
  end)
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
}

return M
