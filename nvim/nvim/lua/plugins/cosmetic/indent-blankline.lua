return {
  -- Add indentation guides even on blank lines
  "lukas-reineke/indent-blankline.nvim",
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  main = "ibl",
  config = function()
    require("ibl").setup({
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "neotest-summary",
          "qf",
          "git",
          "dashboard",
          "dbui",
          "diff",
          "gitcommit",
          "list",
          "help",
          "man",
          "octo_panel",
          "dbout",
          "oil"
        }
      }
    })
  end
}
