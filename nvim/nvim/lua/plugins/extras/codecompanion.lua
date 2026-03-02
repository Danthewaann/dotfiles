return {
  "olimorris/codecompanion.nvim",
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Open [A]I [C]hat",   mode = "n" },
    { "<leader>ac", "<cmd>CodeCompanionChat<CR>",        desc = "Open [A]I [C]hat",   mode = "v" },
    { "<leader>aa", "<cmd>CodeCompanionActions<CR>",     desc = "Open [A]I [A]ctions" }
  },
  opts = {
    interactions = {
      chat = {
        adapter = "anthropic",
        model = "claude-sonnet-4-20250514",
        keymaps = {
          send = {
            modes = { n = "<CR>", i = "<nop>" },
          },
          close = {
            modes = { n = "q", i = "<nop>" },
          },
          stop = {
            modes = {
              n = "<C-x>",
            },
          }
        },
      },
      inline = {
        adapter = "anthropic",
        model = "claude-sonnet-4-20250514",
      },
      cmd = {
        adapter = "anthropic",
        model = "claude-sonnet-4-20250514",
      },
      background = {
        adapter = "anthropic",
        model = "claude-sonnet-4-20250514",
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
