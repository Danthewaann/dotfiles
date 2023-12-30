return {
  "nvim-pack/nvim-spectre",
  event = "VeryLazy",
  config = function()
    local spectre = require("spectre")

    vim.keymap.set("n", "<leader>gsa", spectre.open, { desc = "[G]lobal [S]earch [A]ll" })
    vim.keymap.set("n", "<leader>gsw", function()
      spectre.open_visual({ select_word = true })
    end, { desc = "[G]lobal [S]earch [W]ord" })
    vim.keymap.set(
      "v",
      "<leader>gsw",
      '<esc><cmd>lua require("spectre").open_visual()<CR>',
      { desc = "[G]lobal [S]earch [W]ord" }
    )
  end,
}
