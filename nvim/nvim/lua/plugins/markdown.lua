return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown",
  enabled = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Mandatory
    "nvim-tree/nvim-web-devicons",     -- Optional but recommended
  },
  ft = { "markdown", "octo" },
  config = function()
    require("render-markdown").setup({
      enabled = false,
      file_types = { "markdown", "octo" },
    })

    vim.keymap.set("n", "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", { desc = "[T]oggle [M]arkdown view" })
  end,
}
