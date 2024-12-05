return {
  "linrongbin16/gitlinker.nvim",
  config = function()
    require("gitlinker").setup()

    vim.keymap.set(
      { "n", "v" },
      "<leader>gy",
      "<cmd>GitLink<cr>",
      { silent = true, noremap = true, desc = "Yank git permlink" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>gY",
      "<cmd>GitLink!<cr>",
      { silent = true, noremap = true, desc = "Open git permlink" }
    )

    vim.keymap.set(
      { "n", "v" },
      "<leader>gb",
      "<cmd>GitLink blame<cr>",
      { silent = true, noremap = true, desc = "Yank git blame link" }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>gB",
      "<cmd>GitLink! blame<cr>",
      { silent = true, noremap = true, desc = "Open git blame link" }
    )
  end
}
