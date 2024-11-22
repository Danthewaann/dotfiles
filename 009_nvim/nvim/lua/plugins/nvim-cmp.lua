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
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({})

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

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" }
      }
    })

    local default_cmp_sources = cmp.config.sources(
      {
        { name = "lazydev" },
      },
      {
        { name = "luasnip" },
      },
      {
        { name = "nvim_lsp" },
      },
      {
        {
          name = "path",
          option = {
            get_cwd = function()
              return vim.fn.getcwd(-1, -1)
            end
          }
        },
        {
          name = "buffer",
          keyword_length = 2,
          option = {
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
        },
      }
    )

    ---@diagnostic disable-next-line: missing-fields
    cmp.setup({
      formatting = {
        format = function(entry, vim_item)
          -- Kind icons
          vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
          -- Source
          vim_item.menu = ({
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
            latex_symbols = "[LaTeX]",
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
          function(entry1, entry2)
            -- Filter for keyword arguments for python
            local entry1_is_keyword_arg = string.sub(entry1.completion_item.label, -1) == "="
            local entry2_is_keyword_arg = string.sub(entry2.completion_item.label, -1) == "="
            if entry1_is_keyword_arg and entry2_is_keyword_arg then
              return cmp.config.compare.order(entry1, entry2)
            elseif entry1_is_keyword_arg then
              return true
            end
            return cmp.config.compare.order(entry1, entry2)
          end,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
        }
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = "menu,menuone,noinsert" },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
        ["<C-q>"] = cmp.mapping.abort(),
        ["<C-space>"] = cmp.mapping(function()
          local config = {}
          local buf = vim.api.nvim_get_current_buf()
          local filetype = vim.bo[buf].filetype
          -- Disable `nvim_lsp_signature_help` in python files as it isn't good with python
          if filetype ~= "python" then
            config.sources = {
              { name = "nvim_lsp_signature_help", group_index = 1 },
              { name = "nvim_lsp",                group_index = 2 }
            }
          else
            config.sources = {
              { name = "nvim_lsp", group_index = 1 }
            }
          end
          cmp.complete({ config = config })
        end),
        ["<C-l>"] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
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

    -- Disable `nvim_lsp_signature_help` in python files as it isn't good with python
    vim.api.nvim_create_autocmd("BufRead", {
      callback = function(args)
        local filetype = vim.bo[args.buf].filetype

        if filetype ~= "python" then
          local sources = default_cmp_sources
          sources[#sources + 1] = { name = "nvim_lsp_signature_help" }
          cmp.setup.buffer {
            sources = sources
          }
        end
      end
    })
  end
}
