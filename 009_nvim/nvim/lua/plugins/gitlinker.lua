return {
  "ruifm/gitlinker.nvim",
  dependencies = "nvim-lua/plenary.nvim",
  config = function()
    require("gitlinker").setup({ mappings = nil })

    vim.keymap.set("n", "<leader>gy", function()
      require("gitlinker").get_buf_range_url("n")
    end, { desc = "[G]it [Y]ank URL" })
    vim.keymap.set("v", "<leader>gy", function()
      require("gitlinker").get_buf_range_url("v")
    end, { desc = "[G]it [Y]ank URL" })
  end
}
