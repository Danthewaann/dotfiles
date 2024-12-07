return {
  "kevinhwang91/nvim-bqf",
  event = "VeryLazy",
  config = function()
    require("bqf").setup({
      preview = {
        auto_preview = false
      }
    })
  end
}
