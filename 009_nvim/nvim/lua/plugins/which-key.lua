return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup({
      layout = {
        spacing = 1,
        width = { min = 5, max = vim.o.columns },
        height = { min = 5, max = 20 },
      },
      win = { border = "rounded" }
    })
    require("which-key").add({
      { "<leader>b",   group = "[B]reakpoints" },
      { "<leader>b_",  hidden = true },
      { "<leader>c",   group = "[C]ode, [C]ommand" },
      { "<leader>c_",  hidden = true },
      { "<leader>d",   group = "[D]ocment, [D]iff, [DB]" },
      { "<leader>d_",  hidden = true },
      { "<leader>f",   group = "[F]ile" },
      { "<leader>f_",  hidden = true },
      { "<leader>g",   group = "[G]it, [G]enerate, [G]lobal" },
      { "<leader>g_",  hidden = true },
      { "<leader>gl",  group = "[G]it [L]og" },
      { "<leader>gl_", hidden = true },
      { "<leader>gp",  group = "[G]it [P]ush" },
      { "<leader>gp_", hidden = true },
      { "<leader>gs",  group = "[G]lobal [S]earch" },
      { "<leader>gs_", hidden = true },
      { "<leader>h",   group = "Git [H]unk" },
      { "<leader>h_",  hidden = true },
      { "<leader>p",   group = "Command [P]rompt" },
      { "<leader>p_",  hidden = true },
      { "<leader>r",   group = "[R]ename, [R]eplace, [R]estart" },
      { "<leader>r_",  hidden = true },
      { "<leader>s",   group = "[S]earch" },
      { "<leader>s_",  hidden = true },
      { "<leader>t",   group = "[T]est, [T]oggle" },
      { "<leader>t_",  hidden = true },
      { "<leader>v",   group = "[V]imspector" },
      { "<leader>v_",  hidden = true },
      { "<leader>w",   group = "[W]orkspace" },
      { "<leader>w_",  hidden = true },
      { "<leader>x",   group = "Diagnostic lists" },
      { "<leader>x_",  hidden = true },
    })

    require("which-key").add({
      {
        mode = { "v" },
        { "<leader>",   group = "VISUAL <leader>" },
        { "<leader>g",  group = "[G]it, [G]lobal" },
        { "<leader>gs", group = "[G]lobal [S]earch" },
        { "<leader>h",  desc = "Git [H]unk" },
        { "<leader>r",  group = "[R]eplace" },
        { "<leader>s",  group = "[S]earch" },
      },
    })
  end
}
