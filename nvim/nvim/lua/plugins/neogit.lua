return {
  "NeogitOrg/neogit",
  keys = {
    { "<C-g>",       desc = "Git Status" },
    {
      "<leader>gl",
      mode = "x",
      desc = "[G]it [L]og for selection",
    },
    { "<leader>gla", desc = "[G]it [L]og [A]ll" },
    { "<leader>glf", desc = "[G]it [L]og [F]ile" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("neogit").setup({
      -- Hides the hints at the top of the status buffer
      disable_hint = true,
      -- Disables changing the buffer highlights based on where the cursor is.
      disable_context_highlighting = true,
      commit_editor = {
        kind = "vsplit",
      },
      status = {
        recent_commit_count = 50
      },
      mappings = {
        commit_editor = {
          ["<c-c><c-c>"] = false,
          ["<c-c><c-k>"] = false,
        },
        commit_editor_I = {
          ["<c-c><c-c>"] = false,
          ["<c-c><c-k>"] = false,
        },
        rebase_editor = {
          ["<c-c><c-c>"] = false,
          ["<c-c><c-k>"] = false,
        },
        rebase_editor_I = {
          ["<c-c><c-c>"] = false,
          ["<c-c><c-k>"] = false,
        },
        status = {
          ["S"]     = "StageAll",
          ["<c-s>"] = false,
          ["<c-p>"] = false,
          ["y"]     = false,
        },
        popup = {
          ["l"] = false,
          ["O"] = "LogPopup",
          ["v"] = false,
          ["R"] = "RevertPopup",
          ["w"] = false,
          ["b"] = false,
          ["B"] = false,
          ["p"] = "PushPopup",
          ["P"] = "PullPopup",
        }
      }
    })

    -- Git status
    vim.keymap.set("n", "<C-g>", function()
      require("neogit").open({ kind = "replace" })
    end, { desc = "Git Status" })

    -- Git log commands
    vim.keymap.set("n", "<leader>gla", require("neogit").action("log", "log_head", { "--max-count=10000" }),
      { desc = "[G]it [L]og [A]ll" })
    vim.keymap.set("n", "<leader>glf", function()
      require("neogit").action("log", "log_current", { "--max-count=10000", "--", vim.fn.expand("%") })()
    end, { desc = "[G]it [L]og [F]ile" })
    vim.keymap.set("x", "<leader>gl", function()
      vim.cmd([[ execute "normal! \<ESC>" ]])
      local start_pos = vim.api.nvim_buf_get_mark(0, "<")[1]
      local end_pos = vim.api.nvim_buf_get_mark(0, ">")[1]
      require("neogit").action(
        "log",
        "log_current",
        { "-L", start_pos .. "," .. end_pos .. ":" .. vim.fn.expand("%") }
      )()
    end, { desc = "[G]it [L]og for selection" })

    vim.cmd("highlight! link NeogitHunkHeaderHighlight NeogitSectionHeader")
    vim.cmd("highlight! link NeogitHunkHeader NeogitSectionHeader")
    vim.cmd("highlight! link NeogitCommitViewHeader NeogitSectionHeader")
  end
}
