return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({
      padding = false,
      auto_close = true,
    })
    vim.keymap.set("n", "]q", function()
      require("trouble").next({ skip_groups = true, jump = true })
    end, { desc = "Jump to next trouble item" })
    vim.keymap.set("n", "[q", function()
      require("trouble").previous({ skip_groups = true, jump = true })
    end, { desc = "Jump to previous trouble item" })
    vim.keymap.set("n", "<leader>q", function()
      require("trouble").toggle()
    end, { desc = "Trouble toggle" })
    vim.keymap.set("n", "<leader>xw", function()
      require("trouble").toggle("workspace_diagnostics")
    end, { desc = "Trouble toggle workspace diagnostics" })
    vim.keymap.set("n", "<leader>xd", function()
      require("trouble").toggle("document_diagnostics")
    end, { desc = "Trouble toggle document diagnostics" })
    vim.keymap.set("n", "<leader>xq", function()
      require("trouble").toggle("quickfix")
    end, { desc = "Trouble toggle quickfix" })
    vim.keymap.set("n", "<leader>xl", function()
      require("trouble").toggle("loclist")
    end, { desc = "Trouble toggle locationlist" })
  end
}
