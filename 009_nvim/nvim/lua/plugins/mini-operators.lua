return {
  "echasnovski/mini.operators",
  version = "*",
  config = function()
    require("mini.operators").setup({
      replace = {
        prefix = "s"
      }
    })
  end
}
