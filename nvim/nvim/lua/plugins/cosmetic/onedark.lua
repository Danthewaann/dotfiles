return {
  -- Theme inspired by Atom
  "navarasu/onedark.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local colors = require("custom.colours")

    require("onedark").setup({
      style = "darker",
      colors = colors,
      highlights = {
        ["@variable"] = { fg = colors.red },
        ["@lsp.type.variable"] = { fg = colors.red },
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
          elseif token.type == "function" then
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

    vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { bg = colors.bg3 })
    vim.api.nvim_set_hl(0, "LspInfoBorder", { fg = colors.border })
    vim.api.nvim_set_hl(0, "QuickFixLine", { bg = colors.qf_line })
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.border })
    vim.api.nvim_set_hl(0, "NotificationInfo", { fg = colors.border })
    vim.api.nvim_set_hl(0, "NotificationWarning", { fg = colors.border })
    vim.api.nvim_set_hl(0, "NotificationError", { fg = colors.border })
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = colors.border })
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = colors.border })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = colors.border })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = colors.border })
    vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = colors.border })
    vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { fg = colors.border })
    vim.api.nvim_set_hl(0, "NormalFloat", {})
    vim.api.nvim_set_hl(0, "TreesitterContext", { bg = colors.bg1 })
    vim.api.nvim_set_hl(0, "Conceal", {})
    vim.api.nvim_set_hl(0, "Search", { bg = colors.search })
    vim.api.nvim_set_hl(0, "IncSearch", { bg = colors.search })
    vim.api.nvim_set_hl(0, "CurSearch", { fg = colors.black, bg = colors.yellow })
    vim.api.nvim_set_hl(0, "LspReferenceText", { underline = true })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = true })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = true })
    vim.api.nvim_set_hl(0, "PmenuSel", { bg = colors.bg1 })
    vim.api.nvim_set_hl(0, "Pmenu", { fg = colors.light_grey })
    vim.api.nvim_set_hl(0, "ModeMsg", { fg = colors.green })
    vim.api.nvim_set_hl(0, "OctoReviewDiffAdd", { bg = colors.diff_change })
    vim.api.nvim_set_hl(0, "OctoReviewDiffDelete", { bg = colors.diff_change })
    vim.api.nvim_set_hl(0, "OctoReviewDiffAddText", { bg = colors.diff_text })
    vim.api.nvim_set_hl(0, "OctoReviewDiffDeleteText", { bg = colors.diff_text })
    vim.api.nvim_set_hl(0, "TabLineSel", { fg = "#abb2bf", bg = colors.bg1 })
    vim.api.nvim_set_hl(0, "TabLine", { fg = "#828997" })
    vim.api.nvim_set_hl(0, "DashboardHeader", { fg = "#98c379" })
    vim.api.nvim_set_hl(0, "Yank", { fg = colors.purple, bg = colors.bg1 })

    -- Links
    vim.api.nvim_set_hl(0, "SnacksPickerBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "MasonBackdrop", { link = "Normal" })
    vim.api.nvim_set_hl(0, "WinBarNC", { link = "Normal" })
    vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { link = "DiagnosticInfo" })
    vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { link = "DiagnosticHint" })
    vim.api.nvim_set_hl(0, "DiagnosticFloatingOk", { link = "DiagnosticOk" })
    vim.api.nvim_set_hl(0, "LazyBackdrop", { link = "Normal" })
    vim.api.nvim_set_hl(0, "SnacksBackdrop", { link = "Normal" })
    vim.api.nvim_set_hl(0, "SnacksBackdrop_000000", { link = "Normal" })
  end
}
