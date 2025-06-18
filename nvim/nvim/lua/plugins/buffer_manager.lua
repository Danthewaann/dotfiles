return {
  "Danthewaann/buffer_manager.nvim",
  enabled = true,
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
    vim.keymap.set("n", "<leader>bD", function()
      local obj = vim.system({ "rm", "-f", ".nvim_buffers" }):wait()
      if obj.code ~= 0 then
        utils.print_err(obj.stderr)
        return
      end
      utils.print("Deleted buffers list in .nvim_buffers")
    end, { desc = "[B]uffers [D]elete" })
    vim.keymap.set("n", "<C-b>", buf_ui.toggle_quick_menu, { desc = "Toggle buffers list" })
    vim.keymap.set("n", "<M-l>", buf_ui.nav_next, { desc = "Next buffer" })
    vim.keymap.set("n", "<M-h>", buf_ui.nav_prev, { desc = "Previous buffer" })

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

    vim.api.nvim_create_autocmd("UIEnter", {
      group = vim.api.nvim_create_augroup("buffer_manager_load", { clear = true }),
      callback = function()
        if utils.file_exists(".nvim_buffers") then
          buf_ui.load_menu_from_file(".nvim_buffers")
        end
      end
    })
  end
}
