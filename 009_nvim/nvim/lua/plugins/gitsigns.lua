return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  "lewis6991/gitsigns.nvim",
  opts = {
    -- See `:help gitsigns.txt`
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'rounded',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage git hunk" })
      map("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset git hunk" })
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, desc = "Stage git hunk" })
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, desc = "Resert git hunk" })
      map("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
      map("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo staged hunk" })
      map("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
      map("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview git hunk" })
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, { buffer = bufnr, desc = "Git blame current line" })
      map("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "Show diff of buffer" })
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, { buffer = bufnr, desc = "Show diff of buffer" })
      map("n", "<leader>ht", gs.toggle_deleted, { buffer = bufnr, desc = "Toggle deleted lines" })

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr, desc = "Select inner hunk" })

      -- don't override the built-in and fugitive keymaps
      map({ "n", "v" }, "]c", function()
        if vim.wo.diff then
          return "]czz"
        end
        vim.schedule(function()
          gs.next_hunk()
          vim.cmd.normal("zz")
        end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
      map({ "n", "v" }, "[c", function()
        if vim.wo.diff then
          return "[czz"
        end
        vim.schedule(function()
          gs.prev_hunk()
          vim.cmd.normal("zz")
        end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
    end,
  },
}
