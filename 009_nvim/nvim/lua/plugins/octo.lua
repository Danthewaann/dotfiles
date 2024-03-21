return {
  "pwntester/octo.nvim",
  event = "VeryLazy",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
    local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

    require("octo").setup({
      suppress_missing_scope = {
        projects_v2 = true,
      },
      mappings = {
        review_thread = {
          close_review_tab = { lhs = "" }
        },
        review_diff = {
          close_review_tab = { lhs = "" }
        },
        file_panel = {
          close_review_tab = { lhs = "" },
        }
      }
    })

    augroup("octo", { clear = true })
    autocmd("FileType", {
      group = "octo",
      pattern = "octo_panel",
      callback = function()
        vim.keymap.set(
          "n",
          "<leader>vc",
          "<cmd> Octo review commit<CR>",
          { buffer = true, desc = "review commit" }
        )
      end,
    })
  end
}
