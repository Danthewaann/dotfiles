return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown",
  enabled = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Mandatory
    "nvim-tree/nvim-web-devicons",     -- Optional but recommended
  },
  config = function()
    require("render-markdown").setup({
      file_types = { "markdown", "octo" },
    })
  end,
}
