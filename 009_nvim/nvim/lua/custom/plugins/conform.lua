return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
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
