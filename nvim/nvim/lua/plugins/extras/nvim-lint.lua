return {
  "Danthewaann/nvim-lint",
  event = { "BufRead", "BufWritePost", "InsertLeave" },
  config = function()
    require("lint").linters_by_ft = {
      go = { "golangcilint" },
      python = { "mypy" }
    }

    local utils = require("custom.utils")
    local mypy_linter = require("lint").linters.mypy
    mypy_linter.cmd = utils.get_venv_executable_path("mypy")

    vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost", "InsertLeave" }, {
      callback = function()
        -- Only run the linter in buffers that you can modify in order to
        -- avoid superfluous noise, notably within the handy LSP pop-ups that
        -- describe the hovered symbol using Markdown.
        if vim.bo.modifiable then
          require("lint").try_lint()
        end
      end,
    })
  end,
}
