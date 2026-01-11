---@diagnostic disable: missing-fields
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
        max_height = 0.99,
        max_width = 0.99,
        options = {}
      },
      output = {
        open_on_run = false,
      },
      status = {
        enabled = true,
        signs = true,
        virtual_text = false
      },
      summary = {
        animated = false,
        count = false,
        expand_errors = true,
        follow = true,
        mappings = {
          expand = "<Tab>",
          jumpto = "<CR>"
        }
      }
    })
  end
}
