return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false
    })

    vim.keymap.set("n", "<leader>jt", "<cmd>TSJToggle<CR>", { desc = "TS[J] [T]oggle line split or join" })
    vim.keymap.set("n", "<leader>js", "<cmd>TSJSplit<CR>", { desc = "TS[J] [S]plit line" })
    vim.keymap.set("n", "<leader>jj", "<cmd>TSJJoin<CR>", { desc = "TS[J] [J]oin line" })
  end,
}
