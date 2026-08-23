return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  cmd = "GenerateDocs",
  opts = { snippet_engine = "luasnip" },
  config = function(opts)
    require("neogen").setup(opts)

    vim.api.nvim_create_user_command("GenerateDocs", function()
      require("neogen").generate()
    end, { desc = "Generate docs for code under the cursor" })
  end
}
