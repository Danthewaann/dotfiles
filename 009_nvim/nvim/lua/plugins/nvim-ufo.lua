return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  config = function()
    -- Map of filetypes to foldmethod
    local filetype_folds = { go = "lsp" }

    require("ufo").setup({
      close_fold_kinds_for_ft = {
        go = { "imports" },
        ---@diagnostic disable-next-line: assign-type-mismatch
        python = { "import_from_statement", "import_statement" },
        ---@diagnostic disable-next-line: assign-type-mismatch
        json = { "array" },
        ---@diagnostic disable-next-line: assign-type-mismatch
        yaml = { "block_mapping_pair", "block_sequence_item" }
      },
      open_fold_hl_timeout = 150,
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
        },
      },
      provider_selector = function(bufnr, filetype, buftype)
        return filetype_folds[filetype] or { "treesitter", "indent" }
      end
    })

    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
  end,
}
