return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  event = "VeryLazy",
  opts = { snippet_engine = "luasnip" },
  config = function(opts)
    require("neogen").setup(opts)
    local utils = require("custom.utils")

    utils.create_command("GenerateDocs", function()
      require("neogen").generate()
    end, { desc = "Generate docs for code under the cursor" }, "gen")
  end
}
