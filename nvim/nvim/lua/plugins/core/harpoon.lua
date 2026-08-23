return {
  "Danthewaann/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local utils = require("custom.utils")
    local harpoon = require("harpoon")
    harpoon:setup()

    vim.keymap.set("n", "<leader><space>", function()
      local err_msg = { "Can't add buffer to favourites", { title = "Harpoon" } }
      local buf = vim.api.nvim_get_current_buf()
      local buftype = vim.bo[buf].buftype
      table.unpack = table.unpack or unpack -- 5.1 compatibility
      if buftype ~= "" then
        utils.print_err(table.unpack(err_msg))
        return
      end
      local cur_buf_name = vim.fn.fnamemodify(vim.fn.bufname(), ":.")
      if cur_buf_name == "" then
        utils.print_err(table.unpack(err_msg))
        return
      end

      local list = harpoon:list()
      if list:get_by_value(cur_buf_name) then
        utils.print_warn("Buffer already added to favourites", { title = "Harpoon" })
        return
      end

      list:add()
      utils.print("Added " .. cur_buf_name .. " to favourites", { title = "Harpoon" })
    end, { desc = "Add file to harpoon list" })

    vim.keymap.set("n", "<C-b>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Toggle Harpoon List" })

    vim.keymap.set("n", "<M-h>", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<M-l>", function() harpoon:list():next() end)
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
