return {
  "echasnovski/mini.operators",
  version = "*",
  config = function()
    require("mini.operators").setup({
      evaluate = {
        prefix = "g="
      },
      exchange = {
        prefix = "ge"
      },
      multiply = {
        prefix = "gm"
      },
      replace = {
        prefix = "s"
      },
      sort = {
        prefix = "go"
      }
    })
  end
}
