return {
  "luukvbaal/statuscol.nvim",
  config = function()
    local builtin = require("statuscol.builtin")
    local utils = require("custom.utils")
    require("statuscol").setup({
      relculright = true,
      bt_ignore = { "terminal" },
      ft_ignore = utils.ignore_filetypes,
      segments = {
        {
          text = { " " },
          condition = { builtin.not_empty },
          click = "v:lua.ScLa",
        },
        {
          sign = { namespace = { "gitsigns" }, auto = true },
          click = "v:lua.ScSa"
        },
        {
          sign = { namespace = { "diagnostic/signs" }, auto = true },
          click = "v:lua.ScSa"
        },
        {
          sign = { name = { "vimspector", ".*" }, auto = true },
          click = "v:lua.ScSa"
        },
        {
          text = { builtin.lnumfunc, " " },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        }
      },
    })

    -- From :h diagnostic-handlers-example
    local ns = vim.api.nvim_create_namespace("my_namespace")

    -- Get a reference to the original signs handler
    local orig_signs_handler = vim.diagnostic.handlers.signs

    -- Override the built-in signs handler
    vim.diagnostic.handlers.signs = {
      show = function(_, bufnr, _, opts)
        -- Get all diagnostics from the whole buffer rather than just the
        -- diagnostics passed to the handler
        local diagnostics = vim.diagnostic.get(bufnr)

        -- Find the "worst" diagnostic per line
        local max_severity_per_line = {}
        for _, d in pairs(diagnostics) do
          local m = max_severity_per_line[d.lnum]
          if not m or d.severity < m.severity then
            max_severity_per_line[d.lnum] = d
          end
        end

        -- Pass the filtered diagnostics (with our custom namespace) to
        -- the original handler
        local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
        orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
      end,
      hide = function(_, bufnr)
        orig_signs_handler.hide(ns, bufnr)
      end,
    }
  end,
}
