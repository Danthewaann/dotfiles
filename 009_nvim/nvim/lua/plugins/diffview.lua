return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  cmd = { "DiffviewOpen" },
  config = function()
    local actions = require("diffview.config").actions
    require("diffview").setup({
      keymaps = {
        file_panel = {
          {
            "n",
            "<C-w><C-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<C-w><C-k>",
            function() actions.select_prev_entry() end,
            { desc = "Select previous entry" }
          }
        },
        file_history_panel = {
          {
            "n",
            "<C-w><C-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<C-w><C-k>",
            function() actions.select_prev_entry() end,
            { desc = "Select previous entry" }
          }
        },
        view = {
          {
            "n",
            "<C-w><C-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<C-w><C-k>",
            function() actions.select_prev_entry() end,
            { desc = "Select previous entry" }
          }
        }
      }
    })

    vim.keymap.set("n", "<leader>dv", "<cmd>DiffviewOpen<CR>", {
      desc = "[D]iff [V]iew",
    })
  end,
}
