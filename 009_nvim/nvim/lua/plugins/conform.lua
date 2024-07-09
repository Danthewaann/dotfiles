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
          command = utils.get_poetry_venv_executable_path("ruff"),
          args = {
            "--fix",
            "-e",
            "-n",
            "--ignore",
            "ERA001,F841", -- Don't remove commented out code, unused variables
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
        ruby = { "rubyfmt" },
        -- Use a sub-list to run only the first available formatter
        javascript = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        sql = { "sleek" },
        mysql = { "sleek" },
        plsql = { "sleek" },
        -- Use the "*" filetype to run formatters on all filetypes.
        ["*"] = { "codespell" },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },
      notify_on_error = false
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
      require("conform").format({ lsp_fallback = true, timeout_ms = 3000, range = range })
      vim.cmd(":write")
    end, { range = true, desc = "Format and save current buffer" })
  end,
}
