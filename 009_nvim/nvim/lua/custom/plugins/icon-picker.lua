return {
  "ziontee113/icon-picker.nvim",
  config = function()
    require("icon-picker").setup({
      disable_legacy_commands = true,
    })
    vim.keymap.set("i", "<C-p>", "<cmd>IconPickerInsert<cr>",
      { desc = "Pick an icon to insert", noremap = true, silent = true }
    )
  end,
}
