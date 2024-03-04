return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    -- Adds LSP completion capabilities
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "kristijanhusak/vim-dadbod-completion",

    -- Adds a number of user-friendly snippets
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({})

    -- Set configuration for specific filetype.
    cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
      sources = cmp.config.sources({
        { name = "vim-dadbod-completion" }
      })
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" }
      }
    })

    local window_config = {
      border = "rounded",
      winhighlight = "NormalFloat:CmpNormal"
    }

    ---@diagnostic disable-next-line: missing-fields
    cmp.setup({
      enabled = function()
        -- Disable completion in comments
        -- From: https://github.com/hrsh7th/nvim-cmp/pull/676#issuecomment-1724981778
        local context = require("cmp.config.context")
        local disabled = false
        disabled = disabled or (vim.api.nvim_buf_get_option(0, "buftype") == "prompt")
        disabled = disabled or (vim.fn.reg_recording() ~= "")
        disabled = disabled or (vim.fn.reg_executing() ~= "")
        disabled = disabled or context.in_treesitter_capture("comment")
        return not disabled
      end,
      window = {
        completion = window_config,
        documentation = window_config
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
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-space>"] = cmp.mapping.complete({}),
        ["<C-l>"] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { "i", "s" }),
        ["<C-h>"] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { "i", "s" }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
      },
    })

    -- Make cmp docs look better
    -- From: https://www.reddit.com/r/neovim/comments/180fmw5/add_this_to_make_nvmcmp_docs_look_way_better_in/
    if vim.fn.has("nvim-0.10") == 1 then
      vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
        contents = vim.lsp.util._normalize_markdown(contents, {
          width = vim.lsp.util._make_floating_popup_size(contents, opts),
        })

        vim.bo[bufnr].filetype = "markdown"
        vim.treesitter.start(bufnr)
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

        return contents
      end
    end
  end
}
