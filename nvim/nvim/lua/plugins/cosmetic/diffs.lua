return {
  "https://forge.barrettruth.com/barrettruth/diffs.nvim",
  init = function()
    vim.g.diffs = {
      integrations = {
        fugitive = true,
        gitsigns = true,
      },
      highlights = {
        warn_max_lines = false,
        treesitter = { max_lines = 1000 },
        vim = { max_lines = 500 },
      },
    }
    vim.keymap.set("n", "<leader>co", "<Plug>(diffs-conflict-ours)", { desc = "[C]onflict ours" })
    vim.keymap.set("n", "<leader>ct", "<Plug>(diffs-conflict-theirs)", { desc = "[C]onflict theirs" })
    vim.keymap.set("n", "<leader>cb", "<Plug>(diffs-conflict-both)", { desc = "[C]onflict both" })
    vim.keymap.set("n", "<leader>c0", "<Plug>(diffs-conflict-none)", { desc = "[C]onflict none" })
    vim.keymap.set("n", "]x", "<Plug>(diffs-conflict-next)", { desc = "Next conflict" })
    vim.keymap.set("n", "[x", "<Plug>(diffs-conflict-prev)", { desc = "Previous conflict" })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("MyDiffs", { clear = true }),
      pattern = { "snacks_picker_preview", },
      callback = function(event)
        require("diffs").attach(event.buf)
      end,
    })
  end,
  dependencies = { "lewis6991/gitsigns.nvim" }
}
