return {
  "MeanderingProgrammer/markdown.nvim",
  name = "render-markdown",
  commit = "bfbb46af43c95115a06419ef290e16e2fa2a1941",
  enabled = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Mandatory
    "nvim-tree/nvim-web-devicons",     -- Optional but recommended
  },
  ft = { "markdown", "codecompanion" },
  config = function()
    require("render-markdown").setup({
      enabled = true,
      file_types = { "markdown", "codecompanion" },
    })

    vim.keymap.set("n", "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", { desc = "[T]oggle [M]arkdown view" })
  end,
}
