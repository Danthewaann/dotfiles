require("onedark").setup({
  style = "darker",
  highlights = {
    ["@variable"] = { fg = "#e55561" },
  },
})

require("onedark").load()

vim.cmd("highlight LspSignatureActiveParameter ctermbg=242 guibg=#323641")
vim.cmd("highlight LspInfoBorder guifg=#31353f")
vim.cmd("highlight QuickFixLine gui=None guifg=None guibg=#282c34")
vim.cmd("highlight TelescopePromptBorder guifg=#31353f")
vim.cmd("highlight NotificationInfo guibg=#31353f")
vim.cmd("highlight NotificationWarning guibg=#31353f")
vim.cmd("highlight NotificationError guibg=#31353f")
vim.cmd("highlight TelescopeResultsBorder guifg=#31353f")
vim.cmd("highlight TelescopePreviewBorder guifg=#31353f")
vim.cmd("highlight FloatBorder guifg=#31353f guibg=NONE")
vim.cmd("highlight NormalFloat guibg=NONE")
vim.cmd("highlight TreesitterContext guibg=#282c34")
vim.cmd("highlight Conceal guibg=NONE")
vim.cmd("highlight! link DiagnosticFloatingError DiagnosticError")
vim.cmd("highlight! link DiagnosticFloatingWarn DiagnosticWarn")
vim.cmd("highlight! link DiagnosticFloatingInfo DiagnosticInfo")
vim.cmd("highlight! link DiagnosticFloatingHint DiagnosticHint")
vim.cmd("highlight! link DiagnosticFloatingOk DiagnosticOk")