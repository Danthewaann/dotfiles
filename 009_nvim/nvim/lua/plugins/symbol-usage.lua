return {
  "Wansmer/symbol-usage.nvim",
  event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  config = function()
    local function text_format(symbol)
      local fragments = {}

      if symbol.references then
        local usage = symbol.references <= 1 and "usage" or "usages"
        local num = symbol.references == 0 and "no" or symbol.references
        table.insert(fragments, ("%s %s"):format(num, usage))
      end

      if symbol.definition then
        table.insert(fragments, symbol.definition .. " defs")
      end

      if symbol.implementation then
        table.insert(fragments, symbol.implementation .. " impls")
      end

      local combined = table.concat(fragments, ", ")
      return "-> " .. combined
    end

    local SymbolKind = vim.lsp.protocol.SymbolKind
    local ignoreSymbols = {
      SymbolKind.Property,
      SymbolKind.Field,
      SymbolKind.Constructor,
      SymbolKind.Variable,
      SymbolKind.String,
      SymbolKind.Number,
      SymbolKind.Boolean,
      SymbolKind.Array,
      SymbolKind.Object,
      SymbolKind.Key,
      SymbolKind.Null,
    }

    local symbols = {}
    for _, v in pairs(SymbolKind) do
      if vim.tbl_get(ignoreSymbols, v) == nil then
        symbols[#symbols + 1] = v
      end
    end

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
