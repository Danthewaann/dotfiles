return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    require("lsp_lines").setup()

    -- Enable virtual text by default, but add a toggle to switch
    -- between virtual text and virtual lines
    local use_virtual_text = true
    local virtual_text_or_lines_visible = true
    local virtual_text_config = { source = "always" }
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

    local function configure_virtual_text_and_lines(output)
      output = output or false
      if use_virtual_text then
        if output then
          print("Toggling virtual text")
        end
        diagnostics_config.virtual_text = virtual_text_config
        diagnostics_config.virtual_lines = false
      else
        if output then
          print("Toggling virtual lines")
        end
        diagnostics_config.virtual_text = false
        diagnostics_config.virtual_lines = virtual_lines_config
      end
    end

    -- Setup initial diagnostic config
    vim.diagnostic.config(diagnostics_config)

    vim.keymap.set("n", "<leader>dt", function()
      use_virtual_text = not use_virtual_text

      configure_virtual_text_and_lines(true)

      if virtual_text_or_lines_visible then
        vim.diagnostic.config(diagnostics_config)
      end
    end, { desc = "[D]iagnostic [T]oggle between virtual text and lines" })

    vim.keymap.set("n", "<leader>do", function()
      virtual_text_or_lines_visible = not virtual_text_or_lines_visible

      if virtual_text_or_lines_visible then
        print("Toggling on virtual diagnostics")
        configure_virtual_text_and_lines()
      else
        print("Toggling off virtual diagnostics")
        diagnostics_config.virtual_text = false
        diagnostics_config.virtual_lines = false
      end

      vim.diagnostic.config(diagnostics_config)
    end, { desc = "[D]iagnostic toggle [O]n or [O]ff virtual diagnostics" })
  end,
}
