return {
  "numToStr/BufOnly.nvim",
  config = function ()
    vim.keymap.set("n", "<leader>bo", "<cmd>BufOnly<CR>", { desc = "[B]uffer [O]nly" })
  end
}
