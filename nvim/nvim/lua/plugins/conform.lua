return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  config = function()
    local utils = require("custom.utils")

    require("conform").setup({
      formatters = {
        sleek = {
          command = "sleek",
        },
        ruff_fix = {
          command = utils.get_poetry_venv_executable_path("ruff")
        },
        black = {
          command = utils.get_poetry_venv_executable_path("black")
        },
      },
      formatters_by_ft = {
        -- Conform will run multiple formatters sequentially
        python = { "ruff_fix", "black" },
        ruby = { "rubyfmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        sql = { "sleek" },
        mysql = { "sleek" },
        plsql = { "sleek" },
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = { "codespell" },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace", lsp_format = "prefer" },
      },
      notify_on_error = true
    })

    -- Create a command `:W` to format and save the current buffer
    vim.api.nvim_create_user_command("W", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ timeout_ms = 3000, range = range })
      vim.cmd(":write")
    end, { range = true, desc = "Format and save current buffer" })
  end,
}
