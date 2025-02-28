return {
  "stevearc/oil.nvim",
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      -- Set to false if you still want to use netrw.
      default_file_explorer = true,
      -- Skip the confirmation popup for simple operations
      skip_confirm_for_simple_edits = true,
      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = "yes",
        number = false,
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
      -- Additionally, if it is a string that matches "actions.<name>",
      -- it will use the mapping at require("oil.actions").<name>
      -- Set to `false` to remove a keymap
      -- See :help oil-actions for a list of all available actions
      keymaps = {
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<Tab>"] = "actions.preview",
        ["<C-p>"] = false,
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["<C-l>"] = false,
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        sort = {
          -- sort order can be "asc" or "desc"
          -- see :help oil-columns to see which columns are sortable
          { "type", "asc" },
          { "name", "asc" },
        },
      }
    })

    vim.keymap.set("n", "-", "<cmd> Oil <CR>", { desc = "Open file tree in current dir" })
    vim.keymap.set("n", "_", "<cmd> Oil .<CR>", { desc = "Open file tree in project root" })
  end,
}
