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
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-w><C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-w><C-k>", desc = "move to next changed file" },
        },
        review_diff = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-w><C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-w><C-k>", desc = "move to next changed file" },
        },
        file_panel = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-w><C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-w><C-k>", desc = "move to next changed file" },
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
