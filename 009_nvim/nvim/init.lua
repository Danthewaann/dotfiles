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

      vim.cmd("highlight TelescopePromptBorder guifg=#31353f")
      vim.cmd("highlight TelescopeResultsBorder guifg=#31353f")
      vim.cmd("highlight TelescopePreviewBorder guifg=#31353f")
      vim.cmd("highlight FloatBorder guifg=#31353f guibg=NONE")
      vim.cmd("highlight NvimTreeNormal guibg=#282c34 guifg=#9da5b3")
      vim.cmd("highlight NvimTreeNormalFloat guibg=#282c34 guifg=#9da5b3")
      vim.cmd("highlight NvimTreeEndOfBuffer guibg=#282c34 guifg=#282c34")
    end,
  },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = "ibl",
    opts = {
      scope = { enabled = false },
      exclude = { filetypes = { "undotree" } }
    },
  },

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "piersolenski/telescope-import.nvim"
    },
  },

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

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-q>"] = require("trouble.providers.telescope").open_with_trouble,
      },
      n = {
        ["<C-q>"] = require("trouble.providers.telescope").open_with_trouble,
      },
    },
    -- Cache the last 10 pickers so I can resume them later
    cache_picker = {
      num_pickers = 10,
      limit_entries = 1000,
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },
    file_ignore_patterns = {
      "vendor",
    },
    layout_strategy = "vertical",
    layout_config = {
      vertical = { height = 0.8, width = 0.7, preview_height = 0.4 },
      horizontal = { height = 0.8, width = 0.7, preview_width = 0.55 },
    },
  },
  pickers = {
    live_grep = {
      additional_args = function(_)
        return { "--hidden" }
      end,
    },
  },
})

local utils = require("custom.utils")

-- Enable telescope extensions, if installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "import")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", function()
  require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({
    previewer = false,
    sort_mru = true,
    ignore_current_buffer = true,
  }))
end, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<C-f>", function()
  require("telescope.builtin").git_files({ layout_strategy = "horizontal" })
end, { desc = "Search Git Files" })
vim.keymap.set("n", "<C-p>", function()
  require("telescope.builtin").find_files({ layout_strategy = "horizontal", hidden = true })
end, { desc = "Search Files" })
vim.keymap.set("n", "<leader>sh", function()
  require("telescope.builtin").help_tags({ layout_strategy = "horizontal" })
end, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sm", function()
  require("telescope.builtin").man_pages({ layout_strategy = "horizontal" })
end, { desc = "[S]earch [M]an Pages" })
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>sp", require("telescope.builtin").pickers, { desc = "[S]earch [P]ickers" })
vim.keymap.set("n", "<leader>gf", function()
  require("telescope.builtin").git_status({ layout_strategy = "horizontal" })
end, { desc = "[G]it [F]iles" })
vim.keymap.set("n", "<leader>gl", require("telescope.builtin").git_commits, { desc = "[G]it [L]ogs" })
vim.keymap.set("n", "<leader>ii", require("telescope").extensions.import.import, { desc = "[I]nsert [I]mport" })

-- Search for pattern in current project files
vim.keymap.set("n", "<leader>ps", function()
  vim.ui.input({ prompt = "Project Search:" }, function(search)
    if search then
      require("telescope.builtin").grep_string({ search = search })
    end
  end)
end, { desc = "[P]roject [S]earch" })

-- Search for the current word in project files
vim.keymap.set("n", "<leader>F", require("telescope.builtin").grep_string, { desc = "[F]ind word" })
vim.keymap.set("v", "<leader>F", function()
  require("telescope.builtin").grep_string({ search = utils.get_visual_selection() })
end, { desc = "[F]ind word" })

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
          -- Let pyright handle unused variables, imports
          "--ignore", "F841,F401"
        }
      }
    }
  },
  rust_analyzer = { settings = {} },
  tsserver = { settings = {} },
  html = { settings = {}, filetypes = { "html", "twig", "hbs" } },
  jsonls = { settings = {} },
  sqlls = { settings = {} },
  bashls = { settings = {} },

  lua_ls = {
    settings = {
      Lua = {
        format = {
          enable = true,
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
            quote_style = "double"
          }
        },
        workspace = { checkThirdParty = false },
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
    local server = servers[server_name] or {}
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      init_options = server.init_options,
      settings = server.settings,
      before_init = server.before_init,
      filetypes = server.filetypes,
    })
  end,
})

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup({})

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
  },
})
