return {
  "stevearc/quicker.nvim",
  event = "VeryLazy",
  config = function()
    require("quicker").setup({
      opts = {
        number = true
      }
    })
  end
}
