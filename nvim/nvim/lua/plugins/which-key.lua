return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    require("which-key").setup({
      preset = "modern",
      delay = 500,
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
      { "<leader>d",   group = "[D]iff, [DB], [D]elete, [D]ebug" },
      { "<leader>d_",  hidden = true },
      { "<leader>g",   group = "[G]it, [G]enerate" },
      { "<leader>g_",  hidden = true },
      { "<leader>gl",  group = "[G]it [L]og" },
      { "<leader>gl_", hidden = true },
      { "<leader>gv",  group = "[G]it [V]iew" },
      { "<leader>gv_", hidden = true },
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
    })

    require("which-key").add({
      {
        mode = { "v" },
        { "<leader>",  group = "VISUAL <leader>" },
        { "<leader>d", group = "[D]iff" },
        { "<leader>g", group = "[G]it" },
        { "<leader>h", desc = "Git [H]unk" },
        { "<leader>r", group = "[R]eplace" },
        { "<leader>s", group = "[S]earch" },
      },
    })
  end
}
