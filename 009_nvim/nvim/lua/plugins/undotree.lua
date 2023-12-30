return {
  "mbbill/undotree",
  event = "VeryLazy",
  config = function()
    vim.g.undotree_WindowLayout = 4
    vim.g.undotree_SplitWidth = 40

    vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "Toggle undotree" })
  end
}
