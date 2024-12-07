return {
  "kevinhwang91/nvim-bqf",
  config = function()
    require("bqf").setup({
      preview = {
        auto_preview = false
      }
    })
  end
}
