return {
  "junegunn/gv.vim",
  event = "VeryLazy",
  config = function()
    vim.keymap.set("n", "<leader>gla", ":GV<CR>:set winbar=<CR>", {
      silent = true,
      desc = "[G]it [L]og [A]ll"
    })
    vim.keymap.set("n", "<leader>glf", ":GV!<CR>:set winbar=<CR>", {
      silent = true,
      desc = "[G]it [L]og [F]ile"
    })
    vim.keymap.set("x", "<leader>gl", ":GV<CR>:set winbar=<CR>", {
      silent = true,
      desc = "[G]it [L]og for selection"
    })
  end
}
