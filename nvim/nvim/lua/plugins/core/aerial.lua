return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  opts = {
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
      vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      vim.keymap.set("n", "<C-e>", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial", buffer = bufnr })
    end
  },
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
}
