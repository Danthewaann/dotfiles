return {
  "j-morano/buffer_manager.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    local utils = require("custom.utils")
    local buf_ui = require("buffer_manager.ui")

    vim.keymap.set("n", "<leader>bw", function()
      buf_ui.save_menu_to_file(".nvim_buffers")
      utils.print("Written buffers list to .nvim_buffers")
    end, { desc = "[B]uffers [W]rite" })
    vim.keymap.set("n", "<leader>bl", function()
      buf_ui.load_menu_from_file(".nvim_buffers")
      utils.print("Loaded buffers list from .nvim_buffers")
    end, { desc = "[B]uffers [L]oad" })
    vim.keymap.set("n", "<C-b>", buf_ui.toggle_quick_menu, { desc = "Toggle buffers list" })
    vim.keymap.set("n", "<C-l>", buf_ui.nav_next, { desc = "Next buffer" })
    vim.keymap.set("n", "<C-h>", buf_ui.nav_prev, { desc = "Previous buffer" })

    -- Save the buffer list to `.nvim_buffers` when we `:write` the buffer list
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("buffer_manager_write", { clear = true }),
      pattern = "buffer_manager",
      callback = function(event)
        vim.api.nvim_create_autocmd("BufWriteCmd", {
          group = vim.api.nvim_create_augroup("buffer_manager_write_cmd", { clear = true }),
          buffer = event.buf,
          callback = function()
            buf_ui.on_menu_save()
            buf_ui.save_menu_to_file(".nvim_buffers")
          end
        })
      end
    })
  end
}
