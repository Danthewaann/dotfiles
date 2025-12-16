return {
  "folke/todo-comments.nvim",
  keys = {
    {
      "<leader>st", "<cmd> TodoTelescope<CR>", desc = "[S]earch [T]odos"
    }
  },
  opts = {
    signs = false,
    highlight = {
      multiline = true,                                            -- enable multine todo comments
      multiline_pattern = "^.",                                    -- lua pattern to match the next multiline from the start of the matched keyword
      multiline_context = 10,                                      -- extra lines that will be re-evaluated when changing a line
      before = "",                                                 -- "fg" or "bg" or empty
      keyword = "wide",                                            -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
      after = "fg",                                                -- "fg" or "bg" or empty
      pattern = { [[.*<(KEYWORDS)\(\w+\):]], [[.*<(KEYWORDS):]] }, -- pattern or table of patterns, used for highlighting (vim regex)
      comments_only = true,                                        -- uses treesitter to match keywords in comments only
      max_line_len = 400,                                          -- ignore lines longer than this
      exclude = {},                                                -- list of file types to exclude highlighting
    },
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      pattern = [[(\b(KEYWORDS)\(\w+\)|\b(KEYWORDS)):]]
    }
  },
  dependencies = { "nvim-lua/plenary.nvim" },
}
