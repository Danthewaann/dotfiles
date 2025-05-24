return {
  "mfussenegger/nvim-lint",
  event = "VeryLazy",
  config = function()
    require("lint").linters_by_ft = {
      python = { "dmypy" },
      go = { "golangcilint" },
    }

    local utils = require("custom.utils")

    local dmypy_linter = require("lint").linters.dmypy
    dmypy_linter.cmd = utils.get_poetry_venv_executable_path("dmypy")
    dmypy_linter.append_fname = false
    dmypy_linter.args = utils.dmypy_args()

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
