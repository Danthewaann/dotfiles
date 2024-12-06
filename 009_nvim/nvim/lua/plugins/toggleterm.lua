return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-t><c-t>]],
      shade_terminals = false,
      direction = "horizontal",
      auto_scroll = false,
      persist_size = false,
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      highlights = { FloatBorder = { link = "FloatBorder" } },
      float_opts = {
        border = "rounded",
        relative = "editor",
        anchor = "NE",
        col = vim.o.columns - 20,
        width = function()
          return math.floor(vim.o.columns * 0.5)
        end,
        height = function()
          return vim.api.nvim_win_get_height(0) - 5
        end,
      }
    })
  end
}
