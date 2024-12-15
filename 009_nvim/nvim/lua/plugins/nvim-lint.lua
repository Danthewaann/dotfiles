return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  config = function()
    require("lint").linters_by_ft = {
      python = { "dmypy" },
      go = { "golangcilint" },
    }

    local utils = require("custom.utils")

    -- From: https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/mypy.lua
    local pattern = "([^:]+):(%d+):(%d+):(%d+):(%d+): (%a+): (.*) %[(%a[%a-]+)%]"
    local groups = { "file", "lnum", "col", "end_lnum", "end_col", "severity", "message", "code" }
    local severities = {
      error = vim.diagnostic.severity.ERROR,
      warning = vim.diagnostic.severity.WARN,
      note = vim.diagnostic.severity.HINT,
    }

    require("lint").linters.dmypy = {
      cmd = utils.get_poetry_venv_executable_path("dmypy"),
      stdin = false,
      append_fname = false,
      ignore_exitcode = true,
      stream = "both",
      args = utils.dmypy_args(),
      parser = require("lint.parser").from_pattern(
        pattern,
        groups,
        severities,
        { ["source"] = "mypy" },
        { end_col_offset = 0 }
      )
    }

    vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
