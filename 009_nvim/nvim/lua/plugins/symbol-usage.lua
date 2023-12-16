return {
  "Wansmer/symbol-usage.nvim",
  event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  config = function()
    local utils = require("custom.utils")

    vim.api.nvim_set_hl(0, "SymbolUsageContent", { fg = utils.get_highlight("Comment").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = utils.get_highlight("Function").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = utils.get_highlight("Type").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = utils.get_highlight("@keyword").fg, italic = true })

    local function text_format(symbol)
      local fragments = {}

      if symbol.references > 0 then
        local usage = symbol.references <= 1 and "usage" or "usages"
        local num = symbol.references
        table.insert(fragments, { "󰌹 ", "SymbolUsageRef" })
        table.insert(fragments, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
      end

      if symbol.definition then
        if #fragments > 0 then
          table.insert(fragments, { " ", "NonText" })
        end
        table.insert(fragments, { "󰳽 ", "SymbolUsageDef" })
        table.insert(fragments, { symbol.definition .. " defs", "SymbolUsageContent" })
      end

      if symbol.implementation then
        if #fragments > 0 then
          table.insert(fragments, { " ", "NonText" })
        end
        table.insert(fragments, { "󰡱 ", "SymbolUsageImpl" })
        table.insert(fragments, { symbol.implementation .. " impls", "SymbolUsageContent" })
      end

      return fragments
    end

    local SymbolKind = vim.lsp.protocol.SymbolKind
    require("symbol-usage").setup({
      text_format = text_format,
      kinds = {
        SymbolKind.Function,
        SymbolKind.Method,
        SymbolKind.Class,
        SymbolKind.Struct,
        SymbolKind.Constant,
      },
      vt_position = "end_of_line",
      filetypes = {
        lua = {
          kinds = {
            SymbolKind.Function,
            SymbolKind.Method,
            SymbolKind.Class,
            SymbolKind.Struct,
          },
        },
        go = {
          kinds = {
            SymbolKind.Function,
            SymbolKind.Method,
            SymbolKind.Class,
            SymbolKind.Struct,
            SymbolKind.Constant,
            SymbolKind.Variable,
            SymbolKind.Field,
          },
        },
      },
    })

    vim.keymap.set(
      "n",
      "<leader>tu",
      ':lua require("symbol-usage").toggle_globally()<CR>',
      { desc = "[T]oggle Symbol [U]sage", silent = true }
    )
  end,
}
