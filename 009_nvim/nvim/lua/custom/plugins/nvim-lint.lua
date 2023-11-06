return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      python = { "mypy" },
      go = { "golangcilint" },
    }

    local utils = require("custom.utils")
    local mypy_linter = require("lint").linters.mypy

    -- Use mypy in virtual environment if found
    mypy_linter.cmd = utils.get_poetry_venv_executable_path("mypy")

    vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
