return {
  "olimorris/codecompanion.nvim",
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Open [A]I [C]hat",   mode = "n" },
    { "<leader>ac", "<cmd>CodeCompanionChat<CR>",        desc = "Open [A]I [C]hat",   mode = "v" },
    { "<leader>aa", "<cmd>CodeCompanionActions<CR>",     desc = "Open [A]I [A]ctions" }
  },
  opts = {
    strategies = {
      chat = {
        adapter = "githubmodels",
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
        adapter = "githubmodels",
      },
      agent = {
        adapter = "githubmodels",
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
