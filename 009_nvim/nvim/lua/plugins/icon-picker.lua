return {
  "ziontee113/icon-picker.nvim",
  event = "VeryLazy",
  config = function()
    require("icon-picker").setup({
      disable_legacy_commands = true,
    })
    vim.keymap.set("i", "<C-p>", "<cmd>IconPickerInsert emoji<cr>",
      { desc = "Pick an emoji to insert", noremap = true, silent = true }
    )
  end,
}
