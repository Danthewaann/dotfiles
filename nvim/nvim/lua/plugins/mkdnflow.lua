return {
  "jakewvincent/mkdnflow.nvim",
  config = function()
    require("mkdnflow").setup({
      to_do = {
        symbols = { " ", "-", "x" },
        complete = "x"
      },
      mappings = {
        MkdnEnter = { { "n", "v", "i" }, "<CR>" },
        MkdnGoBack = false,
        MkdnGoForward = false,
        MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>la" },
        MkdnDestroyLink = { "n", "<leader>ld" },
        MkdnIncreaseHeading = { "n", "<leader>=" },
        MkdnDecreaseHeading = { "n", "<leader>-" },
        MkdnTableNewRowBelow = { "n", "<leader>ir" },
        MkdnTableNewRowAbove = { "n", "<leader>iR" },
        MkdnTableNewColAfter = { "n", "<leader>ic" },
        MkdnTableNewColBefore = { "n", "<leader>iC" },
        MkdnFoldSection = false,
        MkdnUnfoldSection = false,
      }
    })
  end
}
