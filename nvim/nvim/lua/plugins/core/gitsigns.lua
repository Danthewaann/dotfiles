return {
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  "lewis6991/gitsigns.nvim",
  version = "*",
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
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map("n", "<leader>hc", gs.setqflist, { desc = "Show hunks in a quickfix list" })
      map("n", "<leader>hC", function()
        gs.setqflist("all")
      end, { desc = "Show all hunks in a quickfix list" })
      map("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset git hunk" })
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, desc = "Resert git hunk" })
      map("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
      map("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "Show diff of buffer" })
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, { buffer = bufnr, desc = "Show diff of buffer" })

      -- don't override the built-in keymaps
      map({ "n", "v" }, "]c", function()
        if vim.wo.diff then
          return "]czz"
        else
          gs.nav_hunk("next", { preview = false }, function()
            vim.fn.feedkeys("zz")
          end)
        end
      end, { expr = true, buffer = bufnr, desc = "Jump to next hunk" })
      map({ "n", "v" }, "[c", function()
        if vim.wo.diff then
          return "[czz"
        else
          gs.nav_hunk("prev", { preview = false }, function()
            vim.fn.feedkeys("zz")
          end)
        end
      end, { expr = true, buffer = bufnr, desc = "Jump to previous hunk" })
    end,
  },
}
