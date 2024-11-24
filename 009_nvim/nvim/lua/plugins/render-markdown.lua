return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown",
  ft = { "markdown", "octo" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Mandatory
    "nvim-tree/nvim-web-devicons",     -- Optional but recommended
  },
  config = function()
    require("render-markdown").setup({
      file_types = { "markdown", "octo" },
    })

    vim.keymap.set("n", "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", { desc = "[T]oggle [M]arkdown view" })
  end,
}
