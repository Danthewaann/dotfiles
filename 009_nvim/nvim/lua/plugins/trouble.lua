return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end, { desc = "Trouble toggle" })
    vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end,
      { desc = "Trouble toggle workspace diagnostics" })
    vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end,
      { desc = "Trouble toggle document diagnostics" })
    vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end,
      { desc = "Trouble toggle quickfix" })
    vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end,
      { desc = "Trouble toggle locationlist" })
    vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end,
      { desc = "Trouble toggle LSP references" })
  end
}
