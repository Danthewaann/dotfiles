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
        text = message .. " # type: ignore [" .. code .. "]",
        source = "mypy"
      })
    end
  end

  vim.fn.setqflist({}, " ", { title = "Mypy errors", items = list })
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

module.generate_pytest_options = function(mode)
  local options = {}
  -- If pytest-xdist is installed in the current python project, use it when running the suite strategy,
  -- and disable it when running the nearest or file test strategies
  local xdist_installed = vim.system({ "grep", "pytest-xdist", "pyproject.toml" }, { text = true }):wait()
  if mode == "vim-test" then
    options = { nearest = "-vv" }
    local json_report_installed = vim.system({ "grep", "pytest-json-report", "pyproject.toml" }, { text = true }):wait()
    if xdist_installed.code == 0 then
      options.nearest = options.nearest .. " -n 0"
      options.file = "-n 0"
      options.suite = "-n auto"
    end
    if json_report_installed.code == 0 then
      options.nearest = options.nearest .. " --json-report --json-report-file=results.json"
      options.file = options.file .. " --json-report --json-report-file=results.json"
      options.suite = options.suite .. " --json-report --json-report-file=results.json"
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

local ns = vim.api.nvim_create_namespace("pytest_failures")

---Clear all pytest diagnostics across all buffers
function module.clear_diagnostics()
  vim.diagnostic.reset(ns)
end

---Set diagnostics from quickfix items grouped by filename
---@param qf_items table List of quickfix items
local function set_diagnostics(qf_items)
  -- Clear existing diagnostics first
  module.clear_diagnostics()

  -- Group diagnostics by filename
  local by_file = {}
  for _, item in ipairs(qf_items) do
    if item.filename and item.filename ~= "" then
      if not by_file[item.filename] then
        by_file[item.filename] = {}
      end
      table.insert(by_file[item.filename], {
        lnum = item.lnum - 1, -- diagnostics are 0-indexed
        col = 0,
        message = item.text,
        severity = vim.diagnostic.severity.ERROR,
        source = "pytest",
      })
    end
  end

  -- Set diagnostics per buffer
  for filename, diagnostics in pairs(by_file) do
    local bufnr = vim.fn.bufadd(filename)
    vim.fn.bufload(bufnr)
    vim.diagnostic.set(ns, bufnr, diagnostics)
  end
end

function module.load_failures(results_file)
  results_file = results_file or "results.json"

  local f = io.open(results_file, "r")
  if not f then
    vim.notify(("Could not open: %s"):format(results_file), vim.log.levels.ERROR)
    return
  end

  local content = f:read("*a")
  f:close()

  local ok, data = pcall(vim.fn.json_decode, content)
  if not ok or type(data) ~= "table" then
    vim.notify(("Failed to parse JSON from: %s"):format(results_file), vim.log.levels.ERROR)
    return
  end

  local qf_items = {}

  for _, test in ipairs(data.tests or {}) do
    if test.outcome == "failed" then
      local filename = ""
      local lnum = 1
      local text = test.nodeid

      if test.call and test.call.crash then
        local crash = test.call.crash
        filename = crash.path or ""
        lnum = crash.lineno or 1
        text = ("[%s] %s"):format(test.nodeid, crash.message or "")
      end

      table.insert(qf_items, {
        filename = filename,
        lnum = lnum,
        col = 1,
        text = text,
        type = "E",
        valid = 1,
      })
    end
  end

  if #qf_items == 0 then
    vim.notify("No test failures found", vim.log.levels.INFO)
    return
  end

  vim.fn.setqflist({}, "r", {
    title = ("Pytest Failures [%s]"):format(results_file),
    items = qf_items,
  })

  set_diagnostics(qf_items)

  vim.notify(("%d pytest failure(s) loaded into quickfix"):format(#qf_items), vim.log.levels.WARN)
end

-- Register a user command for convenience
vim.api.nvim_create_user_command("PytestLoadFailures", function(opts)
  module.load_failures(opts.args ~= "" and opts.args or nil)
end, {
  nargs = "?",
  complete = "file",
  desc = "Load pytest failures from a results.json file into the quickfix list",
})

vim.api.nvim_create_user_command("PytestClearDiagnostics", function()
  module.clear_diagnostics()
end, {
  desc = "Clear all pytest failure diagnostics",
})


return module
