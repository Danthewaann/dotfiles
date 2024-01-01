return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_theme = "light"
  end,
  ft = { "markdown" },
  config = function()
    vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", {
      silent = true,
      desc = "[M]arkdown [P]review",
    })
  end,
}
