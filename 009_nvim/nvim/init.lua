-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
        opts = {
          sources = {
            pyright = { ignore = true },
          },
        },
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
  },

  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",
      "petertriho/cmp-git",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "davidsierradz/cmp-conventionalcommits",

      -- Adds a number of user-friendly snippets
      "rafamadriz/friendly-snippets",
    },
  },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim",  opts = {} },

  {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "darker",
        toggle_style_key = "<leader>ct",
        toggle_style_list = { "darker", "dark", "cool", "deep", "warm", "warmer" },
        highlights = {
          ["@variable"] = { fg = "#e55561" },
        },
      })

      require("onedark").load()

      vim.cmd("highlight QuickFixLine gui=None guifg=None guibg=#282c34")
      vim.cmd("highlight TelescopePromptBorder guifg=#31353f")
      vim.cmd("highlight TelescopeResultsBorder guifg=#31353f")
      vim.cmd("highlight TelescopePreviewBorder guifg=#31353f")
      vim.cmd("highlight FloatBorder guifg=#31353f guibg=NONE")
      vim.cmd("highlight NvimTreeNormal guibg=#282c34 guifg=#9da5b3")
      vim.cmd("highlight NvimTreeNormalFloat guibg=#282c34 guifg=#9da5b3")
      vim.cmd("highlight NvimTreeEndOfBuffer guibg=#282c34 guifg=#282c34")
    end,
  },

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
  },

  -- For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = "custom.plugins" },
}, {
  -- Don't notify changes as it gets annoying
  change_detection = {
    notify = false,
  },
})

-- [[ Setting options ]]
require("custom.opts")

-- [[ Setting keymaps ]]
require("custom.keymaps")

-- [[ Setting auto commands ]]
require("custom.autocmds")

-- [[ Custom breakpoints code ]]
require("custom.breakpoints")

local utils = require("custom.utils")

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup({
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      "c",
      "cpp",
      "go",
      "lua",
      "python",
      "rust",
      "tsx",
      "javascript",
      "typescript",
      "vimdoc",
      "vim",
      "bash",
      "regex",
      "query",
      "ruby",
      "http",
      "json",
      "markdown",
      "markdown_inline",
      "gitcommit",
      "make",
      "dockerfile",
      "yaml",
      "sql",
      "toml",
    },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = {
      enable = true,
      disable = function(_, buf)
        -- Disable highlighting for large files
        local max_filesize = 200 * 1024 -- 200 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
    },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = "<c-s>",
        node_decremental = "<M-space>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
  })

  if utils.apply_folds(vim.api.nvim_get_current_buf()) then
    -- Refresh the buffer after applying folds to get treesitter to
    -- refresh highlights
    vim.cmd(":e")
  end
end, 0)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({ float = false }) end,
  { desc = "Go to previous diagnostic message" }
)
vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({ float = false }) end,
  { desc = "Go to next diagnostic message" }
)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Open diagnostics list" })

-- [[ Configure LSP ]]
-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>lr", function()
    print("Restarting LSP client...")
    vim.cmd(":LspRestart")
  end, "[R]estart")
  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", function()
    require("telescope.builtin").lsp_definitions()
    utils.unfold()
  end, "[G]oto [D]efinition")
  nmap("gh", function()
    -- Workaround: https://github.com/nvim-telescope/telescope.nvim/issues/2368
    vim.cmd(":vsplit | lua vim.lsp.buf.definition()")
    utils.unfold()
  end, "[G]oto Definition In Vertical Split")
  nmap("gs", function()
    vim.cmd(":split | lua vim.lsp.buf.definition()")
    utils.unfold()
  end, "[G]oto Definition In [S]plit")
  nmap("gr", function()
    require("telescope.builtin").lsp_references({ include_declaration = false, fname_width = 70 })
  end, "[G]oto [R]eferences")
  nmap("gI", function()
    require("telescope.builtin").lsp_implementations()
    utils.unfold()
  end, "[G]oto [I]mplementation")
  nmap("<leader>D", function()
    require("telescope.builtin").lsp_type_definitions()
    utils.unfold()
  end, "Type [D]efinition")
  nmap("<leader>ds", function()
    require("telescope.builtin").lsp_document_symbols({ symbol_width = 70 })
  end, "[D]ocument [S]ymbols")
  nmap("<leader>ws", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols({ fname_width = 70, symbol_width = 70 })
  end, "[W]orkspace [S]ymbols")
  nmap("<leader>ss", function()
    local word = vim.fn.expand("<cword>")
    require("telescope.builtin").lsp_workspace_symbols({
      prompt_title = "LSP Workspace Symbols (" .. word .. ")",
      fname_width = 60,
      symbol_width = 40,
      query = word,
    })
  end, "[S]earch [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
      vim.lsp.buf.hover()
    end
  end, "Hover Documentation")
  nmap("<leader>K", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
end

-- document existing key chains
require("which-key").register({
  ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
  ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
  ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
  ["<leader>h"] = { name = "More git", _ = "which_key_ignore" },
  ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
  ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
  ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
})

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = { settings = {} },
  gopls = { settings = {} },
  pyright = {
    settings = {
      python = {
        analysis = {
          exclude = {
            "**/node_modules",
            "**/__pycache__",
            "migrations/**",
            ".venv/**"
          },
          ignore = {
            "**/node_modules",
            "**/__pycache__",
            "migrations/**",
            ".venv/**"
          },
          typeCheckingMode = "basic",
          diagnosticSeverityOverrides = {
            reportMissingImports = true,
            reportMissingTypeStubs = false,
            reportUnusedImport = false,
          },
          useLibraryCodeForTypes = true
        },
      }
    },
    before_init = function(_, config)
      config.settings.python.pythonPath = utils.get_poetry_venv_executable_path("python", config.root_dir)
    end,
  },
  ruff_lsp = {
    init_options = {
      settings = {
        args = {
          -- Let pyright handle undefined symbols, unused variables, imports
          "--ignore", "F821,F841,F401"
        }
      }
    }
  },
  rust_analyzer = { settings = {} },
  tsserver = { settings = {} },
  html = { settings = {}, filetypes = { "html", "twig", "hbs" } },
  jsonls = { settings = {} },
  sqls = {
    settings = {},
    on_attach = function(client, bufnr)
      require("sqls").on_attach(client, bufnr)
    end,
    filetypes = { "sql" }
  },
  bashls = { settings = {} },

  lua_ls = {
    settings = {
      Lua = {
        -- From: https://github.com/neovim/neovim/issues/21686#issuecomment-1522446128
        runtime = {
          -- Tell the language server which version of Lua you're using
          -- (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {
            "vim",
            "require"
          },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("", true),
        },
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
            quote_style = "double"
          }
        },
        telemetry = { enable = false },
      },
    },
  },
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    local old_deprecate = vim.deprecate

    -- Need to temporarily swap out `vim.deprecate`
    -- to prevent an annoying deprecation warning for sqls
    -- From: https://github.com/neovim/nvim-lspconfig/pull/2544
    if server_name == "sqls" then
      vim.deprecate = function() end
    end

    local server = servers[server_name] or {}
    local local_on_attach = on_attach

    if server.on_attach then
      local_on_attach = function(client, bufnr)
        server.on_attach(client, bufnr)
        on_attach(client, bufnr)
      end
    end

    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = local_on_attach,
      init_options = server.init_options,
      settings = server.settings,
      before_init = server.before_init,
      filetypes = server.filetypes,
    })

    if server_name == "sqls" then
      vim.deprecate = old_deprecate
    end
  end,
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")
require("cmp_git").setup()
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git" },
  }, {
    { name = "buffer" },
  }, {
    { name = "conventionalcommits" },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  }
})

-- Use path source for ':' (if you enabled `native_menu`, this won't work anymore).
---@diagnostic disable-next-line: missing-fields
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  -- From: https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques#disabling-cmdline-completion-for-certain-commands-such-as-increname
  enabled = function()
    -- Set of commands where cmp will be disabled
    local disabled = {
      W = true,
      w = true,
      wa = true,
      q = true,
      qa = true,
    }
    -- Get first word of cmdline
    local cmd = vim.fn.getcmdline():match("%S+")
    -- Return true if cmd isn't disabled
    -- else call/return cmp.close(), which returns false
    return not disabled[cmd] or cmp.close()
  end,
  sources = cmp.config.sources({
    { name = "path" }
  }, {
    { name = "cmdline" }
  })
})

---@diagnostic disable-next-line: missing-fields
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({}),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
})
