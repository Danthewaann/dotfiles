return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      python = { "mypy" },
      go = { "golangcilint" },
    }

    vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
