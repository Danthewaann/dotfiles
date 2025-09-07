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
          -- Run tests with the highest level of verbosity and
          -- don't color the output as neovim doesn't interpret colour escape codes
          args = { "-vvv", "--color=no" },
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
        border = "rounded"
      },
      output = {
        open_on_run = false,
      },
      summary = {
        mappings = {
          expand = "<Tab>",
          jumpto = "<CR>"
        }
      }
    })
  end
}
