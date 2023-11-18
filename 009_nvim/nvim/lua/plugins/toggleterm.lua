return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      shade_terminals = false,
      direction = "vertical",
      size = function(term)
        return vim.o.columns * 0.5
      end
    })
  end
}
