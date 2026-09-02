return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    {
      "williamboman/mason.nvim",
      opts = {
        ui = {
          border = "rounded"
        },
      }
    },
    "williamboman/mason-lspconfig.nvim",
    -- Allows extra capabilities provided by blink.cmp
    "saghen/blink.cmp",

    -- Useful status updates for LSP
    { "j-hui/fidget.nvim",    opts = {} },
    {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = "luvit-meta/library", words = { "vim%.uv" } },
          { path = "snacks.nvim",        words = { "Snacks" } },
        },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true },
  },
  config = function()
    require("lspconfig.ui.windows").default_options.border = "rounded"

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Enable the following language servers
    ---@type table<string, vim.lsp.ClientConfig>
    local servers = {
      clangd = { settings = {} },
      gopls = {
        settings = {
          gopls = {
            semanticTokens = true,
            experimentalPostfixCompletions = true,
            analyses = {
              unusedparams = true,
              shadow = false,
            },
            staticcheck = true,
            gofumpt = true,
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = false,
              constantValues = false,
              functionTypeParameters = false,
              parameterNames = true,
              rangeVariableTypes = true,
            }
          },
        }
      },
      pyrefly = {
        init_options = {
          pyrefly = {
            typeCheckingMode = "off",
            disableTypeErrors = true,
          },
          analysis = { showHoverGoToLinks = false },
        }
      },
      zuban = {
        init_options = { typeCheckingMode = "off" },
        on_attach = function(client)
          -- Disable stuff in favour of pyrefly
          client.server_capabilities.hoverProvider = false
          client.server_capabilities.semanticTokensProvider = nil
          client.server_capabilities.renameProvider = nil
        end,
      },
      -- basedpyright = { settings = { basedpyright = { analysis = { typeCheckingMode = "off" } } } },
      ruff = {
        init_options = {
          settings = {
            configuration = {
              format = {
                preview = true
              },
              lint = {
                preview = false,
                ignore = {
                  "ERA001", -- commented out code
                  "CPY001", -- missing copyright notice at top of file
                }
              }
            }
          }
        }
      },
      rust_analyzer = { settings = {} },
      ts_ls = { settings = {} },
      html = { settings = {}, filetypes = { "html", "twig", "hbs" } },
      jsonls = { settings = {} },
      yamlls = { settings = {} },
      bashls = {
        settings = {
          bashIde = {
            -- Ignore https://www.shellcheck.net/wiki/SC2034
            shellcheckArguments = { "--exclude=SC2034" }
          }
        }
      },
      lua_ls = {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
              disable = { "missing-fields" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false, -- Disable telemetry for privacy
            },
            completion = {
              callSnippet = "Replace"
            },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
                quote_style = "double"
              }
            },
          },
        },
      },
      vimls = { settings = {} },
      marksman = { settings = {} },
      terraformls = { settings = {} }
    }

    -- Only install solargraph LSP if ruby is installed
    local utils = require("custom.utils")
    if utils.file_exists(os.getenv("HOME") .. "/.rbenv") then
      servers["solargraph"] = { settings = {} }
    end

    -- Configure LSP server settings
    for server_name, server in pairs(servers) do
      -- This handles overriding only values explicitly passed
      -- by the server configuration above. Useful when disabling
      -- certain features of an LSP (for example, turning off formatting for ts_ls)
      server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
      vim.lsp.config(server_name, server)
    end

    -- Enable all LSP servers defined above
    local server_names = vim.tbl_keys(servers or {})
    vim.lsp.enable(server_names)

    -- mason-lspconfig requires that these mason is setup first before setting up the servers
    require("mason").setup()
    require("mason-lspconfig").setup({ ensure_installed = server_names })
  end
}
