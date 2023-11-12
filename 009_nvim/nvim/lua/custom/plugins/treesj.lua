return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false
    })

    vim.keymap.set("n", "gT", "<cmd>TSJToggle<CR>", { desc = "TS[J] [T]oggle" })
    vim.keymap.set("n", "gS", "<cmd>TSJSplit<CR>", { desc = "TS[J] [S]plit" })
    vim.keymap.set("n", "gJ", "<cmd>TSJJoin<CR>", { desc = "TS[J] [J]oin" })
  end,
}
