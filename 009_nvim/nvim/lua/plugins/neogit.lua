return {
  "NeogitOrg/neogit",
  event = "VeryLazy",
  config = function()
    require("neogit").setup({
      -- Hides the hints at the top of the status buffer
      disable_hint = true,
      -- Disables changing the buffer highlights based on where the cursor is.
      disable_context_highlighting = true,
      kind = "vsplit",
      commit_editor = {
        kind = "split",
      },
      commit_view = {
        kind = "split",
        verify_commit = os.execute("which gpg") == 0, -- Can be set to true or false, otherwise we try to find the binary
      },
      log_view = {
        kind = "vsplit",
      },
      mappings = {
        status = {
          ["S"] = "StageAll",
          ["<c-s>"] = false,
        },
      }
    })

    -- Git status
    vim.keymap.set("n", "<leader>gg", function()
      require("neogit").open({ kind = "auto" })
    end, { desc = "[G]it [G]et" })

    -- Git push commands
    vim.keymap.set("n", "<leader>gpp", require("neogit").action("push", "to_upstream"), { desc = "[G]it [P]ush" })
    vim.keymap.set(
      "n",
      "<leader>gpf",
      require("neogit").action("push", "to_upstream", { "--force" }),
      { desc = "[G]it [P]ush [F]orce" }
    )

    -- Git log commands
    vim.keymap.set("n", "<leader>gla", require("neogit").action("log", "log_head"), { desc = "[G]it [L]og [A]ll" })
    vim.keymap.set("n", "<leader>glf", function()
      require("neogit").action("log", "log_current", { "--", vim.fn.expand("%") })()
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

    local group = vim.api.nvim_create_augroup("MyCustomNeogitEvents", { clear = true })
    vim.api.nvim_create_autocmd("User", {
      pattern = "NeogitPushComplete",
      group = group,
      callback = function()
        require("neogit").close()
      end,
    })

    vim.cmd("highlight! link NeogitHunkHeaderHighlight NeogitSectionHeader")
    vim.cmd("highlight! link NeogitHunkHeader NeogitSectionHeader")
    vim.cmd("highlight! link NeogitCommitViewHeader NeogitSectionHeader")
  end
}
