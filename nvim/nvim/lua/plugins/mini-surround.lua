return {
  "echasnovski/mini.surround",
  version = "*",
  config = function()
    require("mini.surround").setup({
      mappings = {
        add = "ys",            -- Add surrounding in Normal and Visual modes
        delete = "ds",         -- Delete surrounding
        find = "gs",           -- Find surrounding (to the right)
        find_left = "gF",      -- Find surrounding (to the left)
        highlight = "gh",      -- Highlight surrounding
        replace = "cs",        -- Replace surrounding
        update_n_lines = "gn", -- Update `n_lines`

        suffix_last = "l",     -- Suffix to search with "prev" method
        suffix_next = "n",     -- Suffix to search with "next" method
      },
      search_method = "cover_or_next"
    })

    vim.keymap.del("x", "ys")
    vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

    -- Make special mapping for "add surrounding for line"
    vim.keymap.set("n", "yss", "ys_", { remap = true })
  end
}
