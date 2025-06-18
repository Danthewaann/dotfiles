return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup({
      preset = "modern",
      delay = function(ctx)
        -- Have no deplay for plugins and the spell checking popup with `z=`
        return ctx.plugin and 0 or 500
      end,
      layout = {
        spacing = 1,
        width = { min = 5, max = vim.o.columns },
        height = { min = 5, max = 20 },
      },
      win = { border = "rounded" }
    })
    require("which-key").add({
      { "<leader>a",   group = "[A]I" },
      { "<leader>a_",  hidden = true },
      { "<leader>b",   group = "[B]reakpoints, [B]uffers" },
      { "<leader>b_",  hidden = true },
      { "<leader>c",   group = "[C]ode" },
      { "<leader>c_",  hidden = true },
      { "<leader>d",   group = "[DB], [D]elete, [D]ebug" },
      { "<leader>d_",  hidden = true },
      { "<leader>g",   group = "[G]it, [G]enerate" },
      { "<leader>g_",  hidden = true },
      { "<leader>gl",  group = "[G]it [L]og" },
      { "<leader>gl_", hidden = true },
      { "<leader>h",   group = "Git [H]unk" },
      { "<leader>h_",  hidden = true },
      { "<leader>o",   group = "[O]cto PR review" },
      { "<leader>o_",  hidden = true },
      { "<leader>r",   group = "[R]ename, [R]eplace, [R]estart" },
      { "<leader>r_",  hidden = true },
      { "<leader>s",   group = "[S]earch" },
      { "<leader>s_",  hidden = true },
      { "<leader>t",   group = "[T]est, [T]erminal, [T]oggle" },
      { "<leader>t_",  hidden = true },
      { "<leader>y",   group = "[Y]ank" },
      { "<leader>y_",  hidden = true },
    })

    require("which-key").add({
      {
        mode = { "v" },
        { "<leader>",  group = "VISUAL <leader>" },
        { "<leader>a", group = "[A]I" },
        { "<leader>g", group = "[G]it" },
        { "<leader>h", group = "Git [H]unk" },
        { "<leader>r", group = "[R]eplace" },
        { "<leader>s", group = "[S]earch" },
      },
    })
  end
}
