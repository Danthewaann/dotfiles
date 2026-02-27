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
