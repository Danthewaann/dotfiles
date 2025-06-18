return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  config = function()
    local use_dmypy = false
    local mypy = "mypy"

    if use_dmypy then
      mypy = "dmypy"
    end

    require("lint").linters_by_ft = {
      python = { mypy },
      go = { "golangcilint" },
    }

    local utils = require("custom.utils")

    local mypy_linter = require("lint").linters.mypy
    if use_dmypy then
      mypy_linter = require("lint").linters.dmypy
    end

    mypy_linter.cmd = utils.get_poetry_venv_executable_path(mypy)

    vim.api.nvim_create_autocmd({ "BufRead", "BufWritePost" }, {
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
