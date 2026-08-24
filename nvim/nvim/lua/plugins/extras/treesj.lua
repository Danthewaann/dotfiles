return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    { "gS", "<cmd>TSJToggle<CR>", desc = "Toggle line split or join" }
  },
  opts = {
    use_default_keymaps = false,
    max_join_length = 200
  }
}
