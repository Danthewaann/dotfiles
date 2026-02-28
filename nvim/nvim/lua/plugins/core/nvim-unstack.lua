return {
  "relf108/nvim-unstack",
  version = "*",
  lazy = true,
  cmd = "NvimUnstack",
  opts = {
    layout = "quickfix_list",
    mapkey = false, -- Skip mapping during setup so it doesn't conflict with `keys` config
  },
}
