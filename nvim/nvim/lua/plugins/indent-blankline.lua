return {
  -- Add indentation guides even on blank lines
  "lukas-reineke/indent-blankline.nvim",
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  main = "ibl",
  config = function()
    local utils = require("custom.utils")

    require("ibl").setup({
      scope = { enabled = false },
      exclude = {
        filetypes = utils.ignore_filetypes
      }
    })
  end
}
