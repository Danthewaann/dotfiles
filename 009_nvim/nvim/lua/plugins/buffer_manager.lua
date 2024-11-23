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
    end, { desc = "[B]uffers [W]rite" })
    vim.keymap.set("n", "<leader>bl", function()
      buf_ui.load_menu_from_file(".nvim_buffers")
    end, { desc = "[B]uffers [L]oad" })
    vim.keymap.set("n", "<C-b>", buf_ui.toggle_quick_menu, { desc = "Toggle buffers list" })
    vim.keymap.set("n", "<C-l>", buf_ui.nav_next, { desc = "Next buffer" })
    vim.keymap.set("n", "<C-h>", buf_ui.nav_prev, { desc = "Previous buffer" })

    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("load_buffers_from_file", { clear = true }),
      callback = function()
        if utils.file_exists(".nvim_buffers") then
          vim.schedule(function()
            buf_ui.load_menu_from_file(".nvim_buffers")
            buf_ui.nav_file(1)
          end)
        else
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].filetype == "" then
            MiniStarter.open()
          end
        end
      end
    })
  end
}
