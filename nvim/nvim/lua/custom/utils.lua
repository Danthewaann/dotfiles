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

module.print = function(msg, opts)
  opts = opts or { title = "INFO" }
  vim.notify(msg, vim.log.levels.INFO, opts)
end

module.print_warn = function(msg, opts)
  opts = opts or { title = "WARN" }
  vim.notify(msg, vim.log.levels.WARN, opts)
end

module.print_err = function(err, opts)
  opts = opts or { title = "ERROR" }
  vim.notify(err, vim.log.levels.ERROR, opts)
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
  local json_report_installed = vim.system({ "grep", "pytest-json-report", "pyproject.toml" }, { text = true }):wait()
  if mode == "vim-test" then
    options = {
      nearest = "-vv",
      class = "-vv --force-short-summary",
      file = "-vv --force-short-summary",
      suite = "--force-short-summary",
    }
    if xdist_installed.code == 0 then
      options.nearest = options.nearest .. " -n 0"
      options.class = options.class .. " -n 0"
      options.file = options.file .. " -n 0"
    end
    if json_report_installed.code == 0 then
      local json_report_args = " --json-report --json-report-file=.pytest_results.json"
      options.nearest = options.nearest .. json_report_args
      options.file = options.file .. json_report_args
      options.suite = options.suite .. json_report_args
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

-- Whether the current line spans more than one screen row
module.is_line_wrapped = function()
  if not vim.wo.wrap then
    return false
  end

  local win = vim.api.nvim_get_current_win()
  local text_width = vim.api.nvim_win_get_width(win) - vim.fn.getwininfo(win)[1].textoff

  return vim.fn.virtcol("$") - 1 > text_width
end

module.cabbrev = function(lhs, rhs)
  vim.cmd(string.format("cnoreabbrev <expr> %s getcmdtype() == ':' ? '%s' : '%s'", lhs, rhs, lhs))
end

module.load_pytest_results = function(results_file)
  results_file = results_file or ".pytest_results.json"

  local f = io.open(results_file, "r")
  if not f then
    module.print_err(("Could not open: %s"):format(results_file))
    return
  end

  local content = f:read("*a")
  f:close()

  return vim.fn.json_decode(content)
end

function module.load_pytest_failures(results_file)
  results_file = results_file or ".pytest_results.json"

  local ok, data = pcall(module.load_pytest_results, results_file)
  if not ok or type(data) ~= "table" then
    module.print_err(("Failed to parse JSON from: %s"):format(results_file))
    return
  end

  local qf_items = {}
  local tests = data.tests or {}
  local collectors = data.collectors or {}
  local failed_collectors = {}

  for _, collector in ipairs(collectors) do
    if collector.outcome == "failed" then
      failed_collectors[collector.nodeid] = collector
    end
  end
  for _, collector in pairs(failed_collectors) do
    local filename = collector.nodeid
    local lnum = 1
    local text = collector.longrepr
    local item_module = ""

    table.insert(qf_items, {
      filename = filename,
      lnum = lnum,
      col = 1,
      text = text,
      type = "E",
      valid = 1,
      module = item_module,
    })
  end

  for _, test in ipairs(tests) do
    if test.outcome == "error" then
      if test.setup and test.setup.outcome == "failed" then
        local crash = test.setup.crash
        local longrepr = test.setup.longrepr
        local filename = test.nodeid:match("^[^::]*")
        local lnum = (test.lineno + 1) or 1
        local text = (crash.message or "") .. ("\n\n" .. (longrepr or ""))
        local item_module = test.nodeid or ""
        table.insert(qf_items, {
          filename = filename,
          lnum = lnum,
          col = 1,
          text = text,
          type = "E",
          valid = 1,
          module = item_module,
        })
      end

      if test.teardown and test.teardown.outcome == "failed" then
        local crash = test.teardown.crash
        local filename = test.nodeid:match("^[^::]*")
        local lnum = (test.lineno + 1) or 1
        local text = crash.message or "Failed"
        local item_module = test.nodeid or ""
        table.insert(qf_items, {
          filename = filename,
          lnum = lnum,
          col = 1,
          text = text,
          type = "E",
          valid = 1,
          module = item_module,
        })
      end
    else
      if test.outcome == "failed" then
        local filename = ""
        local lnum = 1
        local text = test.nodeid
        local item_module = ""

        if test.call and test.call.crash then
          local crash = test.call.crash
          filename = test.nodeid:match("^[^::]*")
          lnum = (test.lineno + 1) or 1
          text = crash.message or "Failed"
          item_module = test.nodeid or ""
        end

        table.insert(qf_items, {
          filename = filename,
          lnum = lnum,
          col = 1,
          text = text,
          type = "E",
          valid = 1,
          module = item_module,
        })
      end
    end
  end

  if #qf_items == 0 then
    module.print("No test failures found")
    return
  end

  vim.fn.setqflist({}, "r", {
    title = ("Pytest Failures [%s]"):format(results_file),
    items = qf_items,
  })

  module.print(("%d pytest error(s) loaded into quickfix"):format(#qf_items))
end

return module
