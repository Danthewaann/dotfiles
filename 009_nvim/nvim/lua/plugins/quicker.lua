return {
  "stevearc/quicker.nvim",
  event = "VeryLazy",
  config = function()
    require("quicker").setup({
      opts = {
        number = true
      },
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
        {
          "r",
          require("quicker").refresh,
          desc = "Refresh the quickfix list"
        }
      },
      highlight = {
        -- Use treesitter highlighting
        treesitter = true,
        -- Use LSP semantic token highlighting
        lsp = false,
        -- Load the referenced buffers to apply more accurate highlights (may be slow)
        load_buffers = false,
      },
    })
  end
}
