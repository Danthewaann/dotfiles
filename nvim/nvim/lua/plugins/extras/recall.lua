return {
  "Danthewaann/recall.nvim",
  config = function()
    require("recall").setup({})
    vim.keymap.set("n", "<leader>mm", "<cmd>RecallToggle<CR>", { desc = "[M]ark [M]ake" })
    vim.keymap.set("n", "<M-l>", "<cmd>RecallNext<CR>zz", { desc = "Jump to next mark" })
    vim.keymap.set("n", "<M-h>", "<cmd>RecallPrevious<CR>zz", { desc = "Jump to last mark" })
    vim.keymap.set("n", "<leader>mc", "<cmd>RecallClear<CR>", { desc = "[M]ark [C]lear all" })
    vim.keymap.set("n", "<leader>sm", "<cmd>Telescope recall<CR>", { desc = "[S]earch [M]arks" })
  end
}
