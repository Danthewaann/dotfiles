return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  config = function()
    require("diffview").setup()

    vim.keymap.set("n", "<leader>dv", "<cmd>DiffviewOpen<CR>", {
      desc = "[D]iff [V]iew",
    })
  end,
}
