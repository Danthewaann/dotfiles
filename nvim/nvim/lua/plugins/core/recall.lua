return {
  "fnune/recall.nvim",
  opts = {},
  lazy = false,
  keys = {
    {
      "<leader>mm", "<cmd>RecallToggle<CR>", desc = "Toggle [B]ookmark"
    },
    {
      "<leader>mc", "<cmd>RecallClear<CR>", desc = "[M]ark [C]lear"
    },
    {
      "<leader>sm",
      function()
        require("recall.snacks").pick()
      end,
      desc = "[S]earch [M]arks"
    },
    {
      "<M-h>", "<cmd>RecallPrevious<CR>zz", desc = "Jump to previous mark"
    },
    {
      "<M-l>", "<cmd>RecallNext<CR>zz", desc = "Jump to next mark"
    },
  }
}
