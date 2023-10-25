return {
  "nvim-treesitter/nvim-treesitter-context",
  config = function()
    vim.keymap.set("n", "<leader>k", function()
      require("treesitter-context").go_to_context()
    end, { silent = true })
  end,
}
