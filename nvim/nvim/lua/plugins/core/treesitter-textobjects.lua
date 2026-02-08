return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
    vim.g.no_plugin_maps = true

    -- Or, disable per filetype (add as you like)
    -- vim.g.no_python_maps = true
    -- vim.g.no_ruby_maps = true
    -- vim.g.no_rust_maps = true
    -- vim.g.no_go_maps = true
  end,
  config = function()
    require("nvim-treesitter-textobjects").setup {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V",  -- linewise
          -- ['@class.outer'] = '<c-v>', -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
      },
    }

    vim.keymap.set({ "x", "o" }, "af", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
    end, { desc = "function" })
    vim.keymap.set({ "x", "o" }, "if", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
    end, { desc = "function" })
    vim.keymap.set({ "x", "o" }, "ac", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
    end, { desc = "class" })
    vim.keymap.set({ "x", "o" }, "ic", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
    end, { desc = "class" })
    vim.keymap.set({ "x", "o" }, "ah", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@assignment.lhs", "textobjects")
    end, { desc = "left-hand side of assignment" })
    vim.keymap.set({ "x", "o" }, "al", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@assignment.rhs", "textobjects")
    end, { desc = "right-hand side of assignment" })
    vim.keymap.set({ "x", "o" }, "ia", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@parameter.inner", "textobjects")
    end, { desc = "parameter" })
    vim.keymap.set({ "x", "o" }, "aa", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@parameter.outer", "textobjects")
    end, { desc = "parameter" })
    vim.keymap.set({ "x", "o" }, "as", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
    end, { desc = "scope" })
    vim.keymap.set("n", "]a", function()
      require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
    end, { desc = "Swap with next parameter" })
    vim.keymap.set("n", "[a", function()
      require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
    end, { desc = "Swap with previous parameter" })
    vim.keymap.set("n", "]f", function()
      require("nvim-treesitter-textobjects.swap").swap_next "@function.outer"
    end, { desc = "Swap with next function" })
    vim.keymap.set("n", "[f", function()
      require("nvim-treesitter-textobjects.swap").swap_previous "@function.outer"
    end, { desc = "Swap with previous function" })
  end,
}
