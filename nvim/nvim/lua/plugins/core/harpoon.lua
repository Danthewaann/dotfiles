return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader><space>", function() harpoon:list():add() end, { desc = "Add file to harpoon list" })
    vim.keymap.set("n", "<leader>th", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "[T]oggle [H]arpoon List" })
    vim.keymap.set("n", "<C-h>", function() harpoon:list():prev() end, { desc = "Jump to previous harpoon item" })
    vim.keymap.set("n", "<C-l>", function() harpoon:list():next() end, { desc = "Jump to next harpoon item" })
  end
}
