return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-t>]],
      shade_terminals = false,
      direction = "float",
      auto_scroll = false,
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.5
        end
      end,
      highlights = { FloatBorder = { link = "FloatBorder" } },
      float_opts = { border = "rounded" }
    })
  end
}
