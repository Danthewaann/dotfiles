return {
  "danymat/neogen",
  event = "VeryLazy",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    require("neogen").setup({ snippet_engine = "luasnip" })

    vim.keymap.set("n", "<leader>gd", require("neogen").generate, {
      noremap = true, silent = true, desc = "[G]enerate [D]ocstring"
    })
  end,
}
