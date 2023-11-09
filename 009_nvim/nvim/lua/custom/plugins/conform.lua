return {
  "stevearc/conform.nvim",
  config = function()
    local utils = require("custom.utils")

    require("conform").setup({
      formatters = {
        ruff_fix = {
          command = utils.get_poetry_venv_executable_path("ruff"),
          args = {
            "--fix",
            "-e",
            "-n",
            "--ignore",
            "ERA001", -- Don't remove commented out code
            "--stdin-filename",
            "$FILENAME",
            "-",
          }
        },
        black = {
          command = utils.get_poetry_venv_executable_path("black")
        },
      },
      formatters_by_ft = {
        -- Conform will run multiple formatters sequentially
        python = { "ruff_fix", "black" },
        -- Use a sub-list to run only the first available formatter
        javascript = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        sql = { "sql_formatter" },
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = { "codespell" },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },
    })

    -- Create a command `:W` to format and save the current buffer
    vim.api.nvim_create_user_command("W", function(_)
      local bufnr = vim.api.nvim_get_current_buf()
      require("conform").format({ bufnr = bufnr, timeout_ms = 3000, lsp_fallback = true })
      vim.cmd(":write")
    end, { desc = "Format and save current buffer" })
  end,
}
