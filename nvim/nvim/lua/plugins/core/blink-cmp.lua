local default_sources = function()
  -- put those which will be shown always
  local result = { "lsp", "path", "snippets", "buffer" }
  -- turn on buffer, dictionary and git sources in markdown or text files
  if vim.tbl_contains({ "markdown", "text", "gitcommit" }, vim.bo.filetype) then
    table.insert(result, "dictionary")
    table.insert(result, "git")
  end
  return result
end

return {
  "saghen/blink.cmp",
  event = "VimEnter",
  version = "1.*",
  enabled = true,
  dependencies = {
    -- Snippet Engine
    {
      "L3MON4D3/LuaSnip",
      version = "2.*",
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then return end
        return "make install_jsregexp"
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          "rafamadriz/friendly-snippets",
          config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
          end,
        },
      },
      opts = {},
    },

    -- Extra sources
    "Kaiser-Yang/blink-cmp-git",
    {
      "Kaiser-Yang/blink-cmp-dictionary",
      dependencies = { "nvim-lua/plenary.nvim" }
    },
    "kristijanhusak/vim-dadbod-completion",
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      preset = "default",

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps

      ["<C-space>"] = { function(cmp)
        if cmp.is_visible() then
          cmp.show({ providers = { "buffer", "dictionary" } })
        else
          cmp.show({ providers = default_sources() })
        end
      end, "show", "show_documentation", "hide_documentation" },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    completion = {
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = true, auto_show_delay_ms = 500 },

      -- Disable auto brackets
      -- NOTE: some LSPs may add auto brackets themselves anyway
      accept = { auto_brackets = { enabled = false }, },

      -- Draw the menu to look like nvim-cmp's menu
      menu = { draw = { columns = { { "label", "label_description" }, { "kind_icon", "kind", gap = 1 } } } },
    },

    sources = {
      default = default_sources,

      per_filetype = {
        sql = { "dadbod" },
        lua = { inherit_defaults = true, "lazydev" }
      },

      providers = {
        path = {
          opts = {
            -- Get completions relative to cwd
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
        buffer = {
          opts = {
            -- Show completions from all open buffers
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                return vim.bo[bufnr].buftype == ""
              end, vim.api.nvim_list_bufs())
            end
          },
          score_offset = 100,
        },
        dictionary = {
          module = "blink-cmp-dictionary",
          name = "Dict",
          min_keyword_length = 3,
          opts = {
            dictionary_directories = { vim.fn.expand("~/.config/nvim/dictionary") }
          },
          score_offset = 50,
        },
        git = {
          module = "blink-cmp-git",
          name = "Git",
        },
        dadbod = { module = "vim_dadbod_completion.blink" },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      }
    },

    snippets = { preset = "luasnip" },

    -- Blink.cmp includes a recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- See :h blink-cmp-config-fuzzy for more information
    fuzzy = {
      implementation = "prefer_rust_with_warning",
      sorts = {
        -- Filter for keyword arguments for python
        function(entry1, entry2)
          local entry1_is_keyword_arg = string.sub(entry1.label, -1) == "="
          local entry2_is_keyword_arg = string.sub(entry2.label, -1) == "="
          if entry1_is_keyword_arg and entry2_is_keyword_arg then
            return nil
          elseif entry1_is_keyword_arg then
            return true
          elseif entry2_is_keyword_arg then
            return false
          end
          return nil
        end,
        -- default sorts
        "score",
        "sort_text",
      }
    },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  },
}
