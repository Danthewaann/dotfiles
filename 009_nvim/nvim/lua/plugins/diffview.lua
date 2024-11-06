return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  cmd = { "DiffviewOpen" },
  config = function()
    local actions = require("diffview.config").actions
    require("diffview").setup({
      file_panel = {
        listing_style = "list",
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {},
        },
      },
      keymaps = {
        file_panel = {
          {
            "n",
            "<M-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<M-k>",
            function() actions.select_prev_entry() end,
            { desc = "Select previous entry" }
          }
        },
        file_history_panel = {
          {
            "n",
            "<M-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<M-k>",
            function() actions.select_prev_entry() end,
            { desc = "Select previous entry" }
          }
        },
        view = {
          {
            "n",
            "<M-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<M-k>",
            function() actions.select_prev_entry() end,
            { desc = "Select previous entry" }
          }
        }
      }
    })

    vim.keymap.set("n", "<leader>dv", "<cmd>DiffviewOpen<CR>", {
      desc = "[D]iff [V]iew",
    })
    vim.keymap.set("n", "<leader>gla", ":DiffviewFileHistory<CR>", {
      silent = true,
      desc = "[G]it [L]og [A]ll"
    })
    vim.keymap.set("n", "<leader>glf", ":DiffviewFileHistory %<CR>", {
      silent = true,
      desc = "[G]it [L]og [F]ile"
    })
    vim.keymap.set("x", "<leader>gl", ":DiffviewFileHistory<CR>", {
      silent = true,
      desc = "[G]it [L]og for selection"
    })
  end,
}
