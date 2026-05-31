local utils = require("custom.utils")

vim.api.nvim_create_user_command("Mypy", function()
  utils.print("Running mypy...")
  vim.system(
    {
      utils.get_venv_executable_path("mypy"),
      "--show-column-numbers",
      "--show-error-end",
      "--show-error-codes",
      "--hide-error-context",
      "--no-color-output",
      "--no-error-summary",
      "--no-pretty",
      "."
    }, {}, function(obj)
      vim.schedule(function()
        if obj.code > 1 then
          utils.print_err(vim.fn.trim(obj.stderr))
          return
        end

        -- From: https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/mypy.lua
        local output = obj.stdout
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
        if #list > 0 then
          utils.print_err("Mypy found " .. #list .. " error(s)")
        else
          utils.print("Mypy finished with no errors")
        end
      end)
    end)
end, { desc = "Run Mypy and populate quickfix list with errors" })

vim.api.nvim_create_user_command("Ruff", function()
  utils.print("Running ruff...")
  vim.system(
    {
      utils.get_venv_executable_path("ruff"),
      "check",
      "--force-exclude",
      "--quiet",
      "--no-fix",
      "--output-format",
      "json",
      ".",
    }, {},
    function(obj)
      vim.schedule(function()
        if obj.code > 1 then
          utils.print_err(vim.fn.trim(obj.stderr))
          return
        end

        -- From: https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/ruff.lua
        local output = obj.stdout
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
        if #list > 0 then
          utils.print_err("Ruff found " .. #list .. " error(s)")
        else
          utils.print("Ruff finished with no errors")
        end
      end)
    end)
end, { desc = "Run Ruff and populate quickfix list with errors" })

vim.api.nvim_create_user_command("YankCommits", function(args)
  local count = 1
  if #args.args > 0 then
    count = tonumber(args.args) or 1
  end
  local obj = vim.system({ "sh", "-c", "git log --oneline | head -n " .. count .. " | tac | awk '{print NR \".\", $0}'" })
      :wait()
  if obj.code ~= 0 then
    utils.print_err(vim.fn.trim(obj.stderr))
  end
  local cb_opts = vim.opt.clipboard:get()
  if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", obj.stdout) end
  if vim.tbl_contains(cb_opts, "unnamedplus") then
    vim.fn.setreg("+", obj.stdout)
  end
  vim.fn.setreg("", obj.stdout)
  utils.print("Copied last " .. count .. " commits to clipboard")
end, { desc = "Yank commits to clipboard", nargs = "?" })

vim.api.nvim_create_user_command("DeleteBuffers", function()
  vim.cmd("%bd|e#|bd#")
end, { desc = "Delete All Other Buffers" })

-- Setup command line abbreviations for my custom commands
vim.cmd(":cabbrev mypy Mypy")
vim.cmd(":cabbrev ruff Ruff")
vim.cmd(":cabbrev db DeleteBuffers")
vim.cmd(":cabbrev yc YankCommits")
