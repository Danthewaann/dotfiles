return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      python = { "mypy" },
      go = { "golangcilint" },
    }

    local mypy_linter = require("lint").linters.mypy

    -- Use mypy in virtual environment if found
    ---@diagnostic disable-next-line: assign-type-mismatch
    mypy_linter.cmd = function()
      local local_mypy = vim.fn.fnamemodify(".venv/bin/mypy", ":p")
      local stat = vim.loop.fs_stat(local_mypy)
      if stat then
        return local_mypy
      end
      return "mypy"
    end

    vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
