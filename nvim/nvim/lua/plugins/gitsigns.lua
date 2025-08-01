return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    signs_staged = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    -- See `:help gitsigns.txt`
    preview_config = {
      -- Options passed to nvim_open_win
      border = "rounded",
      style = "minimal",
      relative = "cursor",
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

      map("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage/Unstage git hunk" })
      map("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset git hunk" })
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, desc = "Stage git hunk" })
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, desc = "Resert git hunk" })
      map("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
      map("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
      map("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview git hunk" })
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, { buffer = bufnr, desc = "Git blame current line" })
      map("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "Show diff of buffer" })
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, { buffer = bufnr, desc = "Show diff of buffer" })
      map("n", "<leader>ht", gs.preview_hunk_inline, { buffer = bufnr, desc = "Preview hunk at cursor position inline" })

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { buffer = bufnr, desc = "Select inner hunk" })

      -- don't override the built-in keymaps
      map({ "n", "v" }, "]c", function()
        if vim.wo.diff then
          return "]czz"
        end
        vim.schedule(function()
          gs.nav_hunk("next", { preview = false })
          vim.fn.feedkeys("zz")
        end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
      map({ "n", "v" }, "[c", function()
        if vim.wo.diff then
          return "[czz"
        end
        vim.schedule(function()
          gs.nav_hunk("prev", { preview = false })
          vim.fn.feedkeys("zz")
        end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
    end,
  },
}
