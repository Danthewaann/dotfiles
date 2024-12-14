return {
  "stevearc/quicker.nvim",
  event = "VeryLazy",
  branch = "stevearc-virt-text",
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
      type_icons = {
        E = "",
        W = "",
        I = "",
        N = "",
        H = "",
      },
      highlight = {
        treesitter = false,
        lsp = true,
        load_buffers = false,
      },
    })
  end
}
