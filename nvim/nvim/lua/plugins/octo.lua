return {
  "Danthewaann/octo.nvim",
  event = "VeryLazy",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.treesitter.language.register("markdown", "octo")

    require("octo").setup({
      use_local_fs = true,
      suppress_missing_scope = {
        projects_v2 = true,
      },
      mappings = {
        review_thread = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<M-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<M-k>", desc = "move to next changed file" },
        },
        review_diff = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<M-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<M-k>", desc = "move to next changed file" },
        },
        file_panel = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<M-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<M-k>", desc = "move to next changed file" },
        }
      }
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("octo", { clear = true }),
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
