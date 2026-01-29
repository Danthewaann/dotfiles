return {
  "nvim-mini/mini.jump",
  version = "*",
  keys = { "f", "F", "t", "T" },
  config = function()
    require("mini.jump").setup()
  end
}
