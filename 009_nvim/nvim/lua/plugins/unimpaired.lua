return {
  "tummetott/unimpaired.nvim",
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
