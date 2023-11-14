return {
  "nvim-pack/nvim-spectre",
  config = function()
    local spectre = require("spectre")

    vim.keymap.set("n", "<leader>gs", spectre.open, { desc = "Open Spectre" })
    vim.keymap.set("n", "<leader>sw", function()
      spectre.open_visual({ select_word = true })
    end, { desc = "Search current word" })
    vim.keymap.set(
      "v",
      "<leader>sw",
      '<esc><cmd>lua require("spectre").open_visual()<CR>',
      { desc = "Search current word" }
    )
  end,
}