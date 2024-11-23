return {
  "jakewvincent/mkdnflow.nvim",
  config = function()
    require("mkdnflow").setup({
      to_do = {
        symbols = { " ", "-", "x" },
        complete = "x"
      },
      mappings = {
        MkdnEnter = false,
        MkdnGoBack = false,
        MkdnGoForward = false,
        MkdnCreateLinkFromClipboard = { { "n", "v" }, "gl" },
        MkdnIncreaseHeading = false,
        MkdnDecreaseHeading = false,
      }
    })
  end
}
