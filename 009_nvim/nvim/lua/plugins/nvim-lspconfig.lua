return {
  "neovim/nvim-lspconfig",
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
    "hrsh7th/nvim-cmp",

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
        },
      },
    },
    { "Bilal2453/luvit-meta", lazy = true },
  },
  config = function()
    local utils = require("custom.utils")
    local border = "rounded"
    local show_virtual_text = true

    -- Setup initial diagnostic config
    vim.diagnostic.config({
      virtual_text = show_virtual_text,
      signs = false,
      float = { source = true, border = border },
      severity_sort = true
    })

    -- Toggle virtual text on and off
    vim.keymap.set("n", "<leader>tt", function()
      show_virtual_text = not show_virtual_text
      if show_virtual_text then
        utils.print("Toggling on virtual text")
      else
        utils.print("Toggling off virtual text")
      end
      vim.diagnostic.config({ virtual_text = show_virtual_text })
    end, { desc = "[T]oggle virtual [T]ext" })

    -- Styling for floating windows
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = border,
      }
    )
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = border,
      }
    )
    require("lspconfig.ui.windows").default_options.border = border

    -- Diagnostic keymaps
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })

    local pyright_diagnostic_mode = "openFilesOnly"

    -- [[ Configure LSP ]]
    -- This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(client, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      if client.name == "basedpyright" then
        client.settings.basedpyright.analysis.diagnosticMode = pyright_diagnostic_mode
        nmap("<leader>rd", function()
          if pyright_diagnostic_mode == "openFilesOnly" then
            pyright_diagnostic_mode = "workspace"
          else
            pyright_diagnostic_mode = "openFilesOnly"
          end
          vim.cmd(":LspRestart")
          utils.print("Restarting LSP with diagnosticMode=" .. pyright_diagnostic_mode)
        end, "Reset Diagnostic Mode")
      end

      nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
      nmap("gh", function()
        -- Workaround: https://github.com/nvim-telescope/telescope.nvim/issues/2368
        vim.cmd(":vsplit | lua vim.lsp.buf.definition()")
      end, "[G]oto Definition In Vertical Split")
      nmap("gs", function()
        vim.cmd(":split | lua vim.lsp.buf.definition()")
      end, "[G]oto Definition In [S]plit")
      nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
      nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
      nmap("gO", require("telescope.builtin").lsp_outgoing_calls, "[G]oto [O]utgoing Calls")
      nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
      nmap("<leader>sd", require("telescope.builtin").lsp_document_symbols, "[S]earch [D]ocument Symbols")
      nmap("<leader>sW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[S]earch [W]orkspace Symbols")
      nmap("<leader>ss", function()
        local word = vim.fn.expand("<cword>")
        require("telescope.builtin").lsp_workspace_symbols({
          prompt_title = "LSP Workspace Symbols (" .. word .. ")",
          query = word,
        })
      end, "[S]earch [S]ymbol")
      nmap("<leader>sf", function()
        local word = vim.fn.expand("<cword>")
        require("telescope.builtin").lsp_workspace_symbols({
          prompt_title = "LSP Workspace Function Symbols (" .. word .. ")",
          query = word,
          symbols = { "function", "method" }
        })
      end, "[S]earch [F]unction Symbol")

      -- See `:help K` for why this keymap
      nmap("K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, "Hover Documentation")
      nmap("<leader>rl", function()
        utils.print("Restarting LSP client...")
        vim.cmd(":LspRestart")
      end, "[R]estart [L]sp")
      nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
      nmap("<leader>K", vim.lsp.buf.signature_help, "Signature Documentation")

      -- Lesser used LSP functionality
      nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

      -- Enable highlighting usages of the symbol under the cursor if the LSP server supports it
      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end

      -- Enable inlay hints if the LSP server supports it
      if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        nmap("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
        end, "[T]oggle Inlay [H]ints")
      end
    end

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
      gopls = {
        settings = {
          gopls = {
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
      basedpyright = {
        settings = {
          basedpyright = {
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
              diagnosticMode = pyright_diagnostic_mode, -- can be "workspace" or "openFilesOnly"
              typeCheckingMode = "basic",               -- can be "off", "basic", "standard", "strict", "recommended" or "all"
              diagnosticSeverityOverrides = {
                reportMissingImports = true,
                reportMissingTypeStubs = false,
                reportUnusedImport = false,
              },
              useLibraryCodeForTypes = true
            },
          },
          python = {}
        },
        before_init = function(_, config)
          config.settings.python.pythonPath = utils.get_poetry_venv_executable_path("python", false, config.root_dir)
        end,
      },
      ruff = {
        init_options = {
          settings = {
            lint = {
              ignore = {
                -- Let pyright handle the following errors
                "F821",   -- undefined symbols
                "F841",   -- unused variables
                "ERA001", -- commented out code
                "E999",   -- syntax errors
                "PT001",  -- use `@pytest.fixture` over `@pytest.fixture()`
                "PT023",  -- use `@pytest.mark.something` over `@pytest.mark.something()`
              }
            }
          }
        }
      },
      rust_analyzer = { settings = {} },
      ts_ls = { settings = {} },
      html = { settings = {}, filetypes = { "html", "twig", "hbs" } },
      jsonls = { settings = {} },
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
    if utils.file_exists(os.getenv("HOME") .. "/.rbenv") then
      servers["solargraph"] = { settings = {} }
    end

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    -- Add foldingRange capabilities for nvim-ufo
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = false
    }

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
  end
}
