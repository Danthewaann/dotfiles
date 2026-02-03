return {
  "jakewvincent/mkdnflow.nvim",
  ft = "markdown",
  opts = {
    mappings = {
      MkdnEnter = { { "n", "v" }, "<CR>" },
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
  },
}
