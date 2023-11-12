return {
  -- Theme inspired by Atom
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    require("onedark").setup({
      style = "darker",
      toggle_style_key = "<leader>ct",
      toggle_style_list = { "darker", "dark", "cool", "deep", "warm", "warmer" },
      highlights = {
        ["@variable"] = { fg = "#e55561" },
      },
    })

    require("onedark").load()

    vim.cmd("highlight QuickFixLine gui=None guifg=None guibg=#282c34")
    vim.cmd("highlight TelescopePromptBorder guifg=#31353f")
    vim.cmd("highlight TelescopeResultsBorder guifg=#31353f")
    vim.cmd("highlight TelescopePreviewBorder guifg=#31353f")
    vim.cmd("highlight FloatBorder guifg=#31353f guibg=NONE")
    vim.cmd("highlight NvimTreeNormal guibg=#282c34 guifg=#9da5b3")
    vim.cmd("highlight NvimTreeNormalFloat guibg=#282c34 guifg=#9da5b3")
    vim.cmd("highlight NvimTreeEndOfBuffer guibg=#282c34 guifg=#282c34")
  end,
}
