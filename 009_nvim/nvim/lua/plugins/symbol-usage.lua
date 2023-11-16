return {
  "Wansmer/symbol-usage.nvim",
  event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  config = function()
    local function h(name) return vim.api.nvim_get_hl(0, { name = name }) end

    vim.api.nvim_set_hl(0, "SymbolUsageContent", { fg = h("Comment").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, italic = true })

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
      kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Class, SymbolKind.Struct, SymbolKind.Constant },
      vt_position = "end_of_line",
      filetypes = {
        lua = {
          kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Class, SymbolKind.Struct },
        },
      },
    })

    vim.keymap.set(
      "n",
      "<leader>sut",
      ':lua require("symbol-usage").toggle()<CR>',
      { desc = "[S]ymbol [U]sage [T]oggle", silent = true }
    )
  end,
}
