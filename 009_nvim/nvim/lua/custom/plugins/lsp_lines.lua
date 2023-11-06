return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    require("lsp_lines").setup()

    -- Enable virtual text by default, but add a toggle to switch
    -- between virtual text and virtual lines
    local virtual_text = true
    local virtual_lines_config = { only_current_line = false, highlight_whole_line = true }
    local config = { virtual_text = virtual_text, virtual_lines = virtual_lines_config }

    -- Setup initial diagnostic config
    vim.diagnostic.config({
      virtual_text = virtual_text,
      signs = { enable = true },
      virtual_lines = false,
    })

    vim.keymap.set("", "<leader>l", function()
      virtual_text = not virtual_text
      if virtual_text then
        print("Toggling virtual text")
        config.virtual_text = true
        config.virtual_lines = false
      else
        print("Toggling virtual lines")
        config.virtual_text = false
        config.virtual_lines = virtual_lines_config
      end
      vim.diagnostic.config(config)
    end, { desc = "Toggle between LSP virtual lines and virtual text" })
  end,
}
