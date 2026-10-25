return {
  "Wansmer/symbol-usage.nvim",
  event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  config = function()
    local utils = require("custom.utils")

    local get_highlight = function(name)
      return vim.api.nvim_get_hl(0, { name = name })
    end

    vim.api.nvim_set_hl(0, "SymbolUsageContent", { fg = get_highlight("Comment").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = get_highlight("Function").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = get_highlight("Type").fg, italic = true })
    vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = get_highlight("@keyword").fg, italic = true })

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
      request_pending_text = false,
      disable = {
        lsp = {}
      },
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
      symbol_filter = function(ctx)
        return function(symbol)
          -- Only filter symbols for python code
          if vim.bo[ctx.bufnr].filetype ~= "python" then
            return true
          end
          local file = vim.fn.bufname(ctx.bufnr)
          -- If we are in a python test file, don't search for symbol references
          -- `pytest_language_server` handles references better for fixtures
          return string.find(file, "tests/") == nil
        end
      end
    })

    vim.keymap.set(
      "n",
      "<leader>uu",
      function()
        local active = require("symbol-usage").toggle_globally()
        utils.print("Set symbol usage to " .. tostring(active))
      end,
      { desc = "Toggle Symbol [U]sage", silent = true }
    )
  end,
}
