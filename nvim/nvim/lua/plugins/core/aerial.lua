return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  opts = {
    on_attach = function(bufnr)
      -- Jump forwards/backwards with '{' and '}'
      vim.keymap.set("n", "{", function()
        local count = vim.v.count
        if count == 0 then
          count = 1
        end
        vim.cmd(":" .. count .. "AerialPrev")
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("n", "{", function()
        local count = vim.v.count
        if count == 0 then
          count = 1
        end
        vim.cmd(":" .. count .. "AerialNext")
      end, { buffer = bufnr, silent = true })
      vim.keymap.set("n", "gs", function()
        local count = vim.v.count
        if count == 0 then
          count = 1
        end
        vim.cmd(":" .. count .. "AerialGo")
      end, { desc = "[G]o to [S]ymbol", buffer = bufnr, silent = true })
      vim.keymap.set("n", "<C-e>", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial", buffer = bufnr })
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
