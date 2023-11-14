return {
  "junegunn/gv.vim",
  config = function()
    vim.keymap.set("n", "<leader>gla", ":GV<CR>:set winbar=<CR>", {
      silent = true,
      desc = "[G]it [C]ommits [A]ll"
    })
    vim.keymap.set("n", "<leader>glf", ":GV!<CR>:set winbar=<CR>", {
      silent = true,
      desc = "[G]it [C]ommits [F]ile"
    })
    vim.keymap.set("x", "<leader>gl", ":GV<CR>:set winbar=<CR>", {
      silent = true,
      desc = "[G]it [C]ommits for selection"
    })
  end
}
