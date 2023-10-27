return {
  "ziontee113/icon-picker.nvim",
  config = function()
    require("icon-picker").setup({
      disable_legacy_commands = true,
    })
    vim.keymap.set(
      "n",
      "<leader>pi",
      "<cmd>IconPickerNormal<cr>",
      { desc = "[P]ick [I]con", noremap = true, silent = true }
    )
  end,
}
