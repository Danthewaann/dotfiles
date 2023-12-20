return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  commit = "67b456063966135a05b3a0e1c914b11bc3f03462",
  config = function()
    local utils = require("custom.utils")

    require("ufo").setup({
      enable_get_fold_virt_text = false,
      open_fold_hl_timeout = 150,
      close_fold_kinds = { "imports", "comment" },
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
        -- if you prefer treesitter provider rather than lsp
        -- refer to ./doc/example.lua for detail
        if utils.filetype_folds[filetype] then
          return { "treesitter", "indent" }
        end

        return ""
      end,
    })

    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    vim.keymap.set("n", "zm", require("ufo").closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
    vim.keymap.set("n", "<leader>cf", function()
      require("ufo").closeAllFolds()
      vim.cmd.normal("zAzz")
    end, { desc = "[C]lose all [F]olds not under cursor" })
  end,
}
