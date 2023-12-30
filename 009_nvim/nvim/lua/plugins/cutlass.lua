return {
  "gbprod/cutlass.nvim",
  event = "VeryLazy",
  config = function()
    require("cutlass").setup({
      cut_key = "x",
      override_del = nil,
      exclude = {},
      registers = {
        select = "s",
        delete = "d",
        change = "c",
      },
    })
  end,
}
