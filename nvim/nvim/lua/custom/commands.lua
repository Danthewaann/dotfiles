local utils = require("custom.utils")

vim.api.nvim_create_user_command("Mypy", function()
  utils.print("Running mypy...")
  vim.system(
    utils.mypy_args(true), {}, function(obj)
      vim.schedule(function()
        if obj.code > 1 then
          utils.print_err(vim.fn.trim(obj.stderr))
          return
        end
        utils.print("Finished running mypy")
        utils.parse_mypy_output(obj.stdout)
      end)
    end)
end, { desc = "Run Mypy and populate quickfix list with errors" })

vim.api.nvim_create_user_command("DMypy", function()
  utils.print("Running dmypy...")
  vim.system(
    utils.dmypy_args(true), {}, function(obj)
      vim.schedule(function()
        if obj.code > 1 then
          utils.print_err(vim.fn.trim(obj.stderr))
          return
        end
        utils.print("Finished running dmypy")
        utils.parse_mypy_output(obj.stdout)
      end)
    end)
end, { desc = "Run DMypy and populate quickfix list with errors" })

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
        utils.print("Finished running ruff")
        utils.parse_ruff_output(obj.stdout)
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
