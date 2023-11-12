return {
  "Wansmer/symbol-usage.nvim",
  event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  config = function()
    local function h(name)
      return vim.api.nvim_get_hl(0, { name = name })
    end

    -- hl-groups can have any name
    vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })

    local function text_format(symbol)
      local res = {}

      local round_start = { "", "SymbolUsageRounding" }
      local round_end = { "", "SymbolUsageRounding" }

      if symbol.references then
        local usage = symbol.references <= 1 and "usage" or "usages"
        local num = symbol.references == 0 and "no" or symbol.references
        table.insert(res, round_start)
        table.insert(res, { "󰌹 ", "SymbolUsageRef" })
        table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
        table.insert(res, round_end)
      end

      if symbol.definition then
        if #res > 0 then
          table.insert(res, { " ", "NonText" })
        end
        table.insert(res, round_start)
        table.insert(res, { "󰳽 ", "SymbolUsageDef" })
        table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
        table.insert(res, round_end)
      end

      if symbol.implementation then
        if #res > 0 then
          table.insert(res, { " ", "NonText" })
        end
        table.insert(res, round_start)
        table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
        table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
        table.insert(res, round_end)
      end

      return res
    end

    local function table_contains(tbl, x)
      local found = false
      for _, v in pairs(tbl) do
        if v == x then
          found = true
        end
      end
      return found
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
      if not table_contains(ignoreSymbols, v) then
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
