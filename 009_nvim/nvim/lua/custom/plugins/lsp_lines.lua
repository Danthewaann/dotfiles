return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    require("lsp_lines").setup()

    -- Enable virtual text by default, but add a toggle to switch
    -- between virtual text and virtual lines
    local use_virtual_text = true
    local virtual_text_config = { source = "if_many" }
    local virtual_lines_config = {
      only_current_line = false,
      highlight_whole_line = true,
    }
    local diagnostics_config = {
      virtual_text = virtual_text_config,
      signs = { enable = true },
      float = { source = "always" },
      virtual_lines = false,
    }

    -- Setup initial diagnostic config
    vim.diagnostic.config(diagnostics_config)

    vim.keymap.set("", "<leader>l", function()
      use_virtual_text = not use_virtual_text
      if use_virtual_text then
        print("Toggling virtual text")
        diagnostics_config.virtual_text = virtual_text_config
        diagnostics_config.virtual_lines = false
      else
        print("Toggling virtual lines")
        diagnostics_config.virtual_text = false
        diagnostics_config.virtual_lines = virtual_lines_config
      end
      vim.diagnostic.config(diagnostics_config)
    end, { desc = "Toggle between LSP virtual lines and virtual text" })
  end,
}
