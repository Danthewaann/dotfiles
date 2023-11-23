return {
  "echasnovski/mini.files",
  version = "*",
  config = function()
    require("mini.files").setup()

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesWindowOpen',
      callback = function(args)
        local win_id = args.data.win_id

        -- Customize window-local settings
        vim.wo[win_id].winblend = 5
      end,
    })

    local minifiles_toggle = function(...)
      if not MiniFiles.close() then MiniFiles.open(...) end
    end

    vim.keymap.set("n", "<leader>fb", minifiles_toggle, { desc = "[F]ile [B]rowser" })
    vim.keymap.set("n", "<leader>ff", function()
      minifiles_toggle(vim.api.nvim_buf_get_name(0))
    end, { desc = "[F]ile [F]ind" })
  end
}
