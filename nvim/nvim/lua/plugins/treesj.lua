return {
  "Wansmer/treesj",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
      max_join_length = 200
    })

    vim.keymap.set("n", "gS", "<cmd>TSJToggle<CR>", { desc = "Toggle line split or join" })
  end,
}
