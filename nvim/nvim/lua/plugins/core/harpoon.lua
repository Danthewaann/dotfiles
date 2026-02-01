return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader><space>", function() harpoon:list():add() end, { desc = "Add file to harpoon list" })
    vim.keymap.set("n", "<C-b>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Toggle Harpoon List" })

    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Jump to harpoon item 1" })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Jump to harpoon item 2" })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Jump to harpoon item 3" })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Jump to harpoon item 4" })
    vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "Jump to harpoon item 5" })
    vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end, { desc = "Jump to harpoon item 6" })
    vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end, { desc = "Jump to harpoon item 7" })
    vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end, { desc = "Jump to harpoon item 8" })
    vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end, { desc = "Jump to harpoon item 9" })
  end
}
