return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      "L3MON4D3/LuaSnip",
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
    },
    "saadparwaiz1/cmp_luasnip",

    -- Adds LSP completion capabilities
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-buffer",
    "kristijanhusak/vim-dadbod-completion",
    "uga-rosa/cmp-dictionary",
    "f3fora/cmp-spell",

    -- Adds a number of user-friendly snippets
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local kind_icons = {
      Text = "",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰇽",
      Variable = "󰂡",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    }

    local cmp = require("cmp")
    local types = require("cmp.types")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({})

    -- Function that auto confirms the current selection for use on the cmdline
    local confirm_cmdline = function(fallback)
      if cmp.visible() then
        cmp.confirm()
        -- Press enter to start the search
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "c", false)
      else
        fallback()
      end
    end

    -- Set configuration for specific filetype.
    cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
      sources = cmp.config.sources({
        { name = "vim-dadbod-completion" }
      }),
      mapping = cmp.mapping.preset.insert({
        ["<C-l>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.complete({
              config = {
                sources = {
                  {
                    name = "vim-dadbod-completion",
                    entry_filter = function(entry, _)
                      -- Filter for DB table names
                      return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] == "Class"
                    end
                  }
                }
              }
            })
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline({
        ["<Tab>"] = { c = cmp.config.disable },
        ["<S-Tab>"] = { c = cmp.config.disable },
        ["<C-space>"] = { c = function() cmp.complete() end },
        ["<C-q>"] = { c = cmp.mapping.abort() },
        ["<CR>"] = { c = confirm_cmdline },
      }),
      matching = { disallow_symbol_nonprefix_matching = false },
      sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      enabled = function()
        -- Set of commands where cmp will be disabled
        local disabled = {
          W = true,
          w = true,
          wa = true,
          wq = true,
          q = true,
          qa = true,
        }
        -- Get first word of cmdline
        local cmd = vim.fn.getcmdline():match("%S+")
        -- Return true if cmd isn't disabled
        -- else call/return cmp.close(), which returns false
        return not disabled[cmd] or cmp.close()
      end
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline({
        ["<Tab>"] = { c = cmp.config.disable },
        ["<S-Tab>"] = { c = cmp.config.disable },
        ["<C-space>"] = { c = function() cmp.complete() end },
        ["<C-q>"] = { c = cmp.mapping.abort() },
        ["<CR>"] = { c = confirm_cmdline },
      }),
      sources = { { name = "buffer" } },
    })

    local buffer_source_option = {
      get_bufnrs = function()
        local bufs = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
          if byte_size < 1024 * 1024 then -- 1 Megabyte max
            bufs[buf] = true
          end
        end
        return vim.tbl_keys(bufs)
      end
    }

    local default_cmp_sources = cmp.config.sources(
      { { name = "lazydev" }, },
      { { name = "luasnip", max_item_count = 5 }, { name = "nvim_lsp" }, { name = "nvim_lsp_signature_help" } },
      {
        {
          name = "buffer",
          keyword_length = 2,
          option = buffer_source_option
        },
        { name = "dictionary", keyword_length = 2, max_item_count = 10 },
        {
          name = "path",
          option = {
            get_cwd = function()
              return vim.fn.getcwd(-1, -1)
            end
          },
          max_item_count = 10,
        }
      },
      {
        {
          name = "spell",
          option = { keep_all_entries = true },
          max_item_count = 10,
        },
      }
    )

    local current_source_group = 1

    ---@diagnostic disable-next-line: missing-fields
    cmp.setup({
      formatting = {
        format = function(entry, vim_item)
          -- Don't show entry kind if we are in the cmdline
          if vim.api.nvim_get_mode().mode == "c" then
            vim_item.kind = nil
            return vim_item
          end

          -- Kind icons
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
          -- Source
          vim_item.menu = ({
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
            latex_symbols = "[LaTeX]",
            dictionary = "[Dictionary]",
            spell = "[Spell]",
            ["vim-dadbod-completion"] = "[DB]"
          })[entry.source.name]
          return vim_item
        end
      },
      view = {
        entries = {
          name = "custom",
          follow_cursor = true,
        }
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          -- Show `buffer` source entries first over `dictionary` source entries
          function(entry1, entry2)
            local source1 = entry1.source.name
            local source2 = entry2.source.name

            if source1 == "buffer" and source2 == "dictionary" then
              return true
            elseif source1 == "dictionary" and source2 == "buffer" then
              return false
            end

            return nil
          end,
          -- Filter for keyword arguments for python
          function(entry1, entry2)
            local entry1_is_keyword_arg = string.sub(entry1.completion_item.label, -1) == "="
            local entry2_is_keyword_arg = string.sub(entry2.completion_item.label, -1) == "="
            if entry1_is_keyword_arg and entry2_is_keyword_arg then
              return nil
            elseif entry1_is_keyword_arg then
              return true
            elseif entry2_is_keyword_arg then
              return false
            end
            return nil
          end,
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.length,
          cmp.config.compare.order,
        }
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = "menu,menuone,noinsert" },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = {
          i = function()
            if cmp.visible() then
              cmp.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })
            else
              cmp.complete()
            end
          end,
        },
        ["<C-p>"] = {
          i = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })
            else
              fallback()
            end
          end,
        },
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
        ["<C-q>"] = cmp.mapping.abort(),
        ["<C-space>"] = cmp.mapping(function()
          if current_source_group == 1 then
            current_source_group = 2
            cmp.complete({
              config = {
                sources = {
                  {
                    name = "buffer",
                    option = buffer_source_option,
                  },
                  {
                    name = "dictionary",
                    keyword_length = 2,
                  },
                  {
                    name = "spell",
                    option = { keep_all_entries = true },
                    max_item_count = 10,
                  },
                },
              }
            })
          elseif current_source_group == 2 then
            current_source_group = 1
            cmp.complete()
          end
        end),
        ["<C-l>"] = cmp.mapping(function(fallback)
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif cmp.visible() then
            cmp.complete({
              config = {
                sources = {
                  {
                    name = "nvim_lsp",
                    entry_filter = function(entry, _)
                      -- Filter for keyword arguments in Python
                      if string.sub(entry.completion_item.label, -1) == "=" then
                        return true
                      end
                      return false
                    end
                  }
                }
              }
            })
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = default_cmp_sources
    })

    require("cmp_dictionary").setup({
      paths = { "/usr/share/dict/words" },
      exact_length = 2,
    })
  end
}
