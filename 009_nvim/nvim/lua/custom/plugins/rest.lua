return {
  "rest-nvim/rest.nvim",
  commit = "8b62563cfb19ffe939a260504944c5975796a682", -- For https://github.com/rest-nvim/rest.nvim/issues/246
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("rest-nvim").setup({
      result_split_horizontal = true,
    })

    vim.keymap.set("n", "<leader>pp", "<Plug>RestNvim", { silent = true })
    vim.keymap.set("n", "<leader>pl", "<Plug>RestNvimPreview", { silent = true })
  end,
}
