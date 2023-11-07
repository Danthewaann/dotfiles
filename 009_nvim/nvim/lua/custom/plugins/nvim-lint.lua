return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      python = { "mypy" },
      go = { "golangcilint" },
      gitcommit = { "commitlint" }
    }

    local utils = require("custom.utils")
    local mypy_linter = require("lint").linters.mypy
    local commit_linter = require("lint").linters.commitlint

    -- Use mypy in virtual environment if found
    mypy_linter.cmd = utils.get_poetry_venv_executable_path("mypy")

    -- From: https://github.com/conventional-changelog/commitlint/issues/613#issuecomment-1061807137
    local npm_root = vim.fn.trim(vim.fn.system("npm root -g"))
    commit_linter.args = { "-x", npm_root .. "/@commitlint/config-conventional" }

    vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
