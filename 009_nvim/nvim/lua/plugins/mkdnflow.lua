return {
  "jakewvincent/mkdnflow.nvim",
  config = function()
    require("mkdnflow").setup({
      mappings = {
        MkdnIncreaseHeading = {"n", "<C-l>"},
        MkdnDecreaseHeading = {"n", "<C-h>"},
      }
    })
  end
}
