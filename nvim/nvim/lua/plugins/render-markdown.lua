return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Mandatory
    "nvim-tree/nvim-web-devicons",     -- Optional but recommended
  },
  ft = { "markdown", "codecompanion" },
  config = function()
    require("render-markdown").setup({
      enabled = false,
      file_types = { "markdown", "codecompanion" }
    })

    vim.keymap.set("n", "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", { desc = "[T]oggle [M]arkdown view" })
  end,
}
