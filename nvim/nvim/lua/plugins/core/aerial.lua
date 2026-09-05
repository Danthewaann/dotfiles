return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  keys = { { "<C-e>", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial" } } },
  opts = {
    backends = {
      ["_"]    = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
      python   = { "lsp", "treesitter" },
      lua      = { "lsp", "treesitter" },
      markdown = { "treesitter" },
    },
    attach_mode = "global",
    show_guides = true,
    autojump = true,
    close_automatic_events = { "unsupported" },
    on_attach = function(bufnr)
      -- Jump forwards/backwards
      vim.keymap.set({ "n", "x" }, "<M-k>", function()
        local count = vim.v.count
        if count == 0 then
          count = 1
        end
        require("aerial").prev(count)
      end, { buffer = bufnr, silent = true })
      vim.keymap.set({ "n", "x" }, "<M-j>", function()
        local count = vim.v.count
        if count == 0 then
          count = 1
        end
        require("aerial").next(count)
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("n", "gs", function()
        local count = vim.v.count
        if count == 0 then
          count = 1
        end
        require("aerial").select({ index = count })
      end, { desc = "[G]o to [S]ymbol", buffer = bufnr, silent = true })
    end,
    disable_max_lines = 0,
    disable_max_size = 0,
    layout = {
      max_width = { 80, 0.4 },
      default_direction = "right",
      win_opts = {
        number = true
      }
    },

  },
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },
}
