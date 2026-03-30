return {
  "alexghergh/nvim-tmux-navigation",
  config = function()
    require("nvim-tmux-navigation").setup({})
    vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd> NvimTmuxNavigateLeft<CR>", { desc = "Go to left window" })
    vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd> NvimTmuxNavigateRight<CR>", { desc = "Go to right window" })
    vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd> NvimTmuxNavigateUp<CR>", { desc = "Go to above window" })
    vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd> NvimTmuxNavigateDown<CR>", { desc = "Go to below window" })
  end
}
