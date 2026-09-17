return {
  "MeanderingProgrammer/render-markdown.nvim",
  enabled = true,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- Mandatory
    "nvim-tree/nvim-web-devicons",     -- Optional but recommended
  },
  ft = { "markdown" },
  config = function()
    require("render-markdown").setup({
      enabled = false,
      file_types = { "markdown" }
    })

    vim.keymap.set("n", "<leader>um", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle Markdown View" })
  end,
}
