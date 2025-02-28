return {
  "kevinhwang91/nvim-bqf",
  event = "VeryLazy",
  config = function()
    require("bqf").setup({
      auto_resize_height = true,
      preview = {
        auto_preview = false
      },
      func_map = {
        split = "",
        vsplit = "",
      }
    })
  end
}
