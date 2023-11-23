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
    mypy_linter.args = {
      "--show-column-numbers",
      "--show-error-end",
      "--show-error-codes",
      "--hide-error-context",
      "--no-color-output",
      "--no-error-summary",
      "--no-pretty",
    }

    -- This is a table of error codes I ignore as I let pyright handle them instead
    local error_codes = { "assignment" }
    for _, code in ipairs(error_codes) do
      table.insert(mypy_linter.args, "--disable-error-code")
      table.insert(mypy_linter.args, code)
    end

    -- From: https://github.com/conventional-changelog/commitlint/issues/613#issuecomment-1061807137
    local npm_root = vim.fn.trim(vim.fn.system("npm root -g"))
    commit_linter.args = {
      "-g",
      os.getenv("HOME") .. "/.commitlintrc.yaml",
      "-x",
      npm_root .. "/@commitlint/config-conventional",
    }

    vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
