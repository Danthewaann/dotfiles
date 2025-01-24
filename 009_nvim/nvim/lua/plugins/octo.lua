return {
  "pwntester/octo.nvim",
  commit = "fe39ac0eedbaedc0db5382ee5ec0e57091d55d9e",
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
      suppress_missing_scope = {
        projects_v2 = true,
      },
      mappings = {
        review_thread = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-k>", desc = "move to next changed file" },
        },
        review_diff = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-k>", desc = "move to next changed file" },
        },
        file_panel = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-k>", desc = "move to next changed file" },
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
