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
      window = { border = "rounded" }
    })
    require("which-key").register({
      ["<leader>b"] = { name = "[B]reakpoints", _ = "which_key_ignore" },
      ["<leader>c"] = { name = "[C]ode, [C]ommand", _ = "which_key_ignore" },
      ["<leader>d"] = { name = "[D]ocment, [D]iff, [DB]", _ = "which_key_ignore" },
      ["<leader>f"] = { name = "[F]ile", _ = "which_key_ignore" },
      ["<leader>g"] = { name = "[G]it, [G]enerate, [G]lobal", _ = "which_key_ignore" },
      ["<leader>gc"] = { name = "[G]it [C]ommit", _ = "which_key_ignore" },
      ["<leader>gh"] = { name = "[G]it [H]ub", _ = "which_key_ignore" },
      ["<leader>gl"] = { name = "[G]it [L]og", _ = "which_key_ignore" },
      ["<leader>gp"] = { name = "[G]it [P]ush", _ = "which_key_ignore" },
      ["<leader>gr"] = { name = "[G]it [R]ebase", _ = "which_key_ignore" },
      ["<leader>gs"] = { name = "[G]lobal [S]earch", _ = "which_key_ignore" },
      ["<leader>gu"] = { name = "[G]it [U]pdate", _ = "which_key_ignore" },
      ["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },
      ["<leader>m"] = { name = "[M]arkdown", _ = "which_key_ignore" },
      ["<leader>p"] = { name = "[P]roject", _ = "which_key_ignore" },
      ["<leader>r"] = { name = "[R]ename, [R]eplace, [R]estart", _ = "which_key_ignore" },
      ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
      ["<leader>t"] = { name = "[T]est, [T]oggle", _ = "which_key_ignore" },
      ["<leader>v"] = { name = "[V]imspector, [V]isual", _ = "which_key_ignore" },
      ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
      ["<leader>x"] = { name = "Diagnostic lists", _ = "which_key_ignore" },
    })

    require("which-key").register({
      ["<leader>"] = { name = "VISUAL <leader>" },
      ["<leader>s"] = { name = "[S]earch" },
      ["<leader>g"] = { name = "[G]it, [G]lobal" },
      ["<leader>gs"] = { name = "[G]lobal [S]earch" },
      ["<leader>h"] = { "Git [H]unk" },
      ["<leader>r"] = { name = "[R]eplace" },
    }, { mode = "v" })
  end
}
