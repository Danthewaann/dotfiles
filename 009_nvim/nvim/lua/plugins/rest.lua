return {
  "rest-nvim/rest.nvim",
  commit = "8b62563cfb19ffe939a260504944c5975796a682", -- For https://github.com/rest-nvim/rest.nvim/issues/246
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("rest-nvim").setup({
      result_split_horizontal = true,
    })

    vim.keymap.set("n", "<leader>ch", "<Plug>RestNvim", { silent = true, desc = "[C]ommand run [H]ttp file" })
    vim.keymap.set("n", "<leader>cc", "<Plug>RestNvimPreview", { silent = true, desc = "[C]ommand get [C]url" })
  end,
}
