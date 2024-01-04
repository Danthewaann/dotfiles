return {
  "tummetott/unimpaired.nvim",
  event = "VeryLazy",
  config = function()
    require("unimpaired").setup({
      keymaps = {
        cnext = false,
        cprevious = false,
        cfirst = false,
        clast = false,
      }
    })
  end
}
