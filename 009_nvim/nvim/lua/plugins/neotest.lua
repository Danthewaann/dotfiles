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
        open = function()
          vim.schedule(function()
            vim.cmd("botright copen")
          end)
        end,
      },
      output = {
        enabled = true,
        open_on_run = false,
      },
    })
  end
}
