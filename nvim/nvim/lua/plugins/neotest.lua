return {
  "nvim-neotest/neotest",
  lazy = true,
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
        require("neotest-python")({
          -- Run tests with higher verbosity
          args = { "-vv" },
          -- Don't discover parametrized tests as this can slow down test discovery by quite a lot
          pytest_discover_instances = false,
        }),
        require("neotest-golang")
      },
      quickfix = {
        enabled = true,
        open = false,
      },
      floating = {
        border = "rounded",
        max_height = 0.9,
        max_width = 0.9,
        options = {}
      },
      output = {
        open_on_run = false,
      },
      summary = {
        animated = false,
        mappings = {
          expand = "<Tab>",
          jumpto = "<CR>"
        }
      }
    })
  end
}
