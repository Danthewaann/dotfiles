return {
  -- Theme inspired by Atom
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    require("onedark").setup({
      style = "darker",
      toggle_style_list = { "darker", "dark", "cool", "deep", "warm", "warmer" },
      highlights = {
        ["@variable"] = { fg = "#e55561" },
      },
    })

    require("onedark").load()

    vim.cmd("highlight LspSignatureActiveParameter ctermbg=242 guibg=#323641")
    vim.cmd("highlight QuickFixLine gui=None guifg=None guibg=#282c34")
    vim.cmd("highlight TelescopePromptBorder guifg=#31353f")
    vim.cmd("highlight TelescopeResultsBorder guifg=#31353f")
    vim.cmd("highlight TelescopePreviewBorder guifg=#31353f")
    vim.cmd("highlight FloatBorder guifg=#31353f guibg=NONE")
    vim.cmd("highlight NormalFloat guibg=NONE")
    vim.cmd("highlight Conceal guibg=NONE")
    vim.cmd("highlight! link DiagnosticFloatingError DiagnosticError")
    vim.cmd("highlight! link DiagnosticFloatingWarn DiagnosticWarn")
    vim.cmd("highlight! link DiagnosticFloatingInfo DiagnosticInfo")
    vim.cmd("highlight! link DiagnosticFloatingHint DiagnosticHint")
    vim.cmd("highlight! link DiagnosticFloatingOk DiagnosticOk")
  end,
}
