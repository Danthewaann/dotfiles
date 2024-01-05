return {
  "Wansmer/treesj",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false
    })

    vim.keymap.set("n", "gS", "<cmd>TSJToggle<CR>", { desc = "Toggle line split or join" })
  end,
}
