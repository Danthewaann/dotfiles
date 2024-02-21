return {
  "echasnovski/mini.sessions",
  version = "*",
  config = function()
    require("mini.sessions").setup()

    vim.keymap.set(
      "n",
      "<leader>es",
      "<cmd> lua MiniSessions.write('Session.vim')<CR>",
      { desc = "S[e]ssion [S]ave" }
    )
  end,
}
