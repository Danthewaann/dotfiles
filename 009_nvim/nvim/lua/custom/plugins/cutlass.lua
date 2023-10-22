return {
  "gbprod/cutlass.nvim",
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
