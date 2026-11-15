return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  config = function()
    require("marks").setup({
      default_mappings = false,
      mappings = {
        toggle = "<leader>mm",
        next = "<M-l>",
        prev = "<M-h>",
        delete_buf = "<leader>mc",
      }
    })
    vim.keymap.set("n", "<leader>ml", "<cmd> MarksQFListAll<CR>", { desc = "[M]arks [L]ist" })
  end
}
