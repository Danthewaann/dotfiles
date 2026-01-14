return {
  "Danthewaann/recall.nvim",
  opts = {},
  lazy = false,
  keys = {
    {
      "<C-b>", "<cmd>RecallToggle<CR>", desc = "Toggle [B]ookmark"
    },
    {
      "<leader>mc", "<cmd>RecallClear<CR>", desc = "[M]ark [C]lear"
    },
    {
      "<leader>sm", "<cmd>Telescope recall<CR>", desc = "[S]earch [M]arks"
    },
    {
      "<M-h>", "<cmd>RecallPrevious<CR>zz", desc = "Jump to previous mark"
    },
    {
      "<M-l>", "<cmd>RecallNext<CR>zz", desc = "Jump to next mark"
    },
  }
}
