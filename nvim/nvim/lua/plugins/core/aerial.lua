return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  opts = {
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      vim.keymap.set("n", "<leader>ta", "<cmd>AerialToggle!<CR>", { desc = "[T]oggle [A]erial", buffer = bufnr })
    end,
    disable_max_lines = 0,
    disable_max_size = 0,
  },
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
}
