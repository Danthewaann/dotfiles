return {
  "stevanmilic/nvim-lspimport",
  config = function()
    vim.keymap.set(
      "n",
      "<leader>ri",
      require("lspimport").import,
      { noremap = true, desc = "[R]esolve [I]mport", }
    )
  end
}
