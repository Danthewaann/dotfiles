return {
  "Danthewaann/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup({
      picker = "snacks",
      use_local_fs = true,
      reviews = { auto_show_threads = true, show_virtual_text = false, focus = "right" },
      ui = {
        use_signcolumn = true, -- show "modified" marks on the sign column
        use_signstatus = true, -- show "modified" marks on the status column
      },
      suppress_missing_scope = { projects_v2 = true },
      enable_builtin = true,
      mappings_disable_default = false,
      mappings = {
        pull_request = {
          review = { lhs = "<localleader>vs" },
          review_start = { lhs = "" },
          review_resume = { lhs = "" },
        },
        submit_win = {
          close_review_tab = { lhs = "" },
        },
        review_thread = {
          close_review_tab = { lhs = "" },
        },
        review_diff = {
          close_review_tab = { lhs = "" },
        },
        file_panel = {
          close_review_tab = { lhs = "" },
        }
      }
    })

    local utils = require("custom.utils")
    utils.create_command("Prr", function()
      local buffers = vim.api.nvim_list_bufs()
      for _, buf in ipairs(buffers) do
        local buf_name = vim.api.nvim_buf_get_name(buf)

        if buf_name:match("^octo://") and vim.api.nvim_get_option_value("modified", { buf = buf }) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
      utils.print("Opening PR...")
      vim.cmd("tabnew | Octo pr")
    end, { desc = "Open PR for current branch" })
  end
}
