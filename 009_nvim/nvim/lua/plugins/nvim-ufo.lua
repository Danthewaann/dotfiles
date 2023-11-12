return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
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
    vim.keymap.set("n", "<leader>zv", function()
      require("ufo").closeAllFolds()
      vim.cmd.normal("zAzz")
    end, { desc = "Close all folds not under cursor" })

    vim.api.nvim_create_autocmd("BufRead", {
      pattern = "*",
      callback = function(e)
        utils.apply_folds(e.buf)
      end,
    })
  end,
}
