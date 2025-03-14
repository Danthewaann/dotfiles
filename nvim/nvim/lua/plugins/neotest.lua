return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "fredrikaverpil/neotest-golang"
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python"),
        require("neotest-golang")
      },
      quickfix = {
        enabled = true
      },
      output = {
        enabled = true,
        open_on_run = false,
      },
      summary = {
        mappings = {
          expand = "<Tab>"
        }
      }
    })
  end
}
