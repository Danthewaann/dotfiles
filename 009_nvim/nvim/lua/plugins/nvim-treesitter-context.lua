return {
  "nvim-treesitter/nvim-treesitter-context",
  config = function()
    require("treesitter-context").setup({
      max_lines = 1
    })

    vim.keymap.set("n", "<leader>k", function()
      require("treesitter-context").go_to_context()
    end, { silent = true, desc = "Jump to context" })
  end,
}
