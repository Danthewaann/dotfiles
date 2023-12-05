return {
  "folke/which-key.nvim",
  config = function()
    require("which-key").setup({
      layout = {
        spacing = 3,
        width = { min = 5, max = 80 },
        height = { min = 5, max = 20 },
      },
    })
    require("which-key").register({
      ["<leader>b"] = { name = "[B]uffer, [B]reakpoints", _ = "which_key_ignore" },
      ["<leader>c"] = { name = "[C]ode, [C]ommand, [C]lose", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "[D]ocument, [D]ebug, [D]iff, [DB]", _ = "which_key_ignore" },
      ["<leader>f"] = { name = "[F]ile, [F]ind", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "[G]it, [G]enerate", _ = "which_key_ignore" },
      ["<leader>gc"] = { name = "[G]it [C]ommit", _ = "which_key_ignore" },
      ["<leader>gh"] = { name = "[G]it [H]ub", _ = "which_key_ignore" },
      ["<leader>gl"] = { name = "[G]it [L]og", _ = "which_key_ignore" },
      ["<leader>gp"] = { name = "[G]it [P]ush", _ = "which_key_ignore" },
      ["<leader>gs"] = { name = "[G]lobal [S]earch", _ = "which_key_ignore" },
      ["<leader>h"] = { name = "More git", _ = "which_key_ignore" },
      ["<leader>i"] = { name = "[I]nsert", _ = "which_key_ignore" },
      ["<leader>j"] = { name = "TS[J]", _ = "which_key_ignore" },
      ["<leader>p"] = { name = "[P]roject", _ = "which_key_ignore" },
      ["<leader>r"] = { name = "[R]ename, [R]eplace, [R]esolve, [R]estart, [R]EPLs", _ = "which_key_ignore" },
      ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "[T]est, [T]oggle", _ = "which_key_ignore" },
      ["<leader>v"] = { name = "[V]imspector, [V]isual", _ = "which_key_ignore" },
      ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
      ["<leader>x"] = { name = "Diagnostic lists", _ = "which_key_ignore" },
    })
  end
}
