return {
  "ruifm/gitlinker.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local gitlinker = require("gitlinker")
    gitlinker.setup({
      opts = {
        add_current_line_on_normal_mode = false
      }
    })

    vim.keymap.set("n", "<leader>gy", function() gitlinker.get_buf_range_url("n") end,
      { silent = true, desc = "[G]it [Y]ank URL" })
    vim.keymap.set("v", "<leader>gy", function() gitlinker.get_buf_range_url("v") end,
      { silent = true, desc = "[G]it [Y]ank URL" })
    vim.keymap.set("n", "<leader>gY",
      function() gitlinker.get_buf_range_url("n", { action_callback = gitlinker.actions.open_in_browser }) end,
      { silent = true, desc = "[G]it open URL in browser" })
    vim.keymap.set("v", "<leader>gY",
      function() gitlinker.get_buf_range_url("v", { action_callback = gitlinker.actions.open_in_browser }) end,
      { silent = true, desc = "[G]it open URL in browser" })
  end
}
