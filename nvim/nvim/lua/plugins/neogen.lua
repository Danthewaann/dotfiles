return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  keys = {
    {
      "<leader>gd",
      function()
        require("neogen").generate()
      end,
      desc = "[G]enerate [D]ocstring"
    }
  },
  opts = { snippet_engine = "luasnip" }
}
