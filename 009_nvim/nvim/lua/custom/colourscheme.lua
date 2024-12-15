require("onedark").setup({
  style = "darker",
  colors = {
    black = "#0e1013",
    bg0 = "#1a1d21",
    bg1 = "#272731",
    bg2 = "#272731",
    bg3 = "#323641",
    bg_d = "#181b20",
    bg_blue = "#61afef",
    bg_yellow = "#e8c88c",
    fg = "#a0a8b7",
    purple = "#bf68d9",
    green = "#8ebd6b",
    orange = "#cc9057",
    blue = "#4fa6ed",
    yellow = "#e2b86b",
    cyan = "#48b0bd",
    red = "#e55561",
    grey = "#535965",
    light_grey = "#7a818e",
    dark_cyan = "#266269",
    dark_red = "#8b3434",
    dark_yellow = "#835d1a",
    dark_purple = "#7e3992",
    diff_add = "#272e23",
    diff_delete = "#2d2223",
    diff_change = "#172a3a",
    diff_text = "#274964",
  },
  highlights = {
    ["@variable"] = { fg = "#e55561" },
    ["@lsp.type.variable"] = { fg = "#e55561" },
  },
})

-- Override certain LSP semantic tokens with treesitter capture groups
vim.api.nvim_create_autocmd("LspTokenUpdate", {
  callback = function(args)
    local token = args.data.token
    local capture = nil
    for _, value in ipairs(vim.treesitter.get_captures_at_pos(args.buf, token.line, token.start_col)) do
      if token.type == "method" then
        if value.capture == "constructor" then
          capture = "@constructor"
          break
        end
      elseif token.type == "variable" then
        if value.capture == "type" then
          capture = "@type"
          break
        elseif value.capture == "function.call" then
          capture = "@function"
          break
        elseif value.capture == "variable.member" then
          capture = "@variable.member"
          break
        elseif value.capture == "property" then
          capture = "@property"
          break
        elseif value.capture == "constant" then
          capture = "@constant"
          break
        end
      end
    end
    if capture ~= nil then
      vim.lsp.semantic_tokens.highlight_token(token, args.buf, args.data.client_id, capture)
    end
  end,
})

require("onedark").load()

vim.cmd("highlight LspSignatureActiveParameter ctermbg=242 guibg=#323641")
vim.cmd("highlight LspInfoBorder guifg=#31353f")
vim.cmd("highlight QuickFixLine gui=None guifg=None guibg=#2a2834")
vim.cmd("highlight TelescopePromptBorder guifg=#31353f")
vim.cmd("highlight NotificationInfo guibg=#31353f")
vim.cmd("highlight NotificationWarning guibg=#31353f")
vim.cmd("highlight NotificationError guibg=#31353f")
vim.cmd("highlight TelescopeResultsBorder guifg=#31353f")
vim.cmd("highlight TelescopePreviewBorder guifg=#31353f")
vim.cmd("highlight FloatBorder guifg=#31353f guibg=NONE")
vim.cmd("highlight NormalFloat guibg=NONE")
vim.cmd("highlight TreesitterContext guibg=#272731")
vim.cmd("highlight Conceal guibg=NONE")
vim.cmd("highlight Search guifg=NONE guibg=#464d5e")
vim.cmd("highlight IncSearch guifg=NONE guibg=#464d5e")
vim.cmd("highlight CurSearch guifg=NONE guibg=#464d5e")
vim.cmd("highlight LspReferenceText gui=underline guifg=NONE guibg=NONE")
vim.cmd("highlight LspReferenceRead gui=underline guifg=NONE guibg=NONE")
vim.cmd("highlight LspReferenceWrite gui=underline guifg=NONE guibg=NONE")
vim.cmd("highlight PmenuSel guifg=#a0a8b7 guibg=#464d5e")
vim.cmd("highlight Pmenu guifg=#a0a8b7 guibg=#272731")
vim.cmd("highlight! link WinBar StatusLine")
vim.cmd("highlight! link WinBarNC Normal")
vim.cmd("highlight! link DiagnosticFloatingError DiagnosticError")
vim.cmd("highlight! link DiagnosticFloatingWarn DiagnosticWarn")
vim.cmd("highlight! link DiagnosticFloatingInfo DiagnosticInfo")
vim.cmd("highlight! link DiagnosticFloatingHint DiagnosticHint")
vim.cmd("highlight! link DiagnosticFloatingOk DiagnosticOk")
vim.cmd("highlight! link LazyBackdrop Normal")
vim.cmd("highlight TabLineSel guifg=#abb2bf guibg=#272731")
vim.cmd("highlight TabLine guifg=#828997")
