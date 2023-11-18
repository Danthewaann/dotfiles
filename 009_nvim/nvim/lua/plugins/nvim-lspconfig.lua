return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/nvim-cmp",

    -- Useful status updates for LSP
    {
      "j-hui/fidget.nvim",
      opts = {
        progress = {
          display = {
            format_message = function(msg)
              if msg.lsp_name == "pyright" and string.find(msg.title, "Finding references") then
                return nil -- Ignore pyright "Finding references" progress messages
              end
              if msg.message then
                return msg.message
              else
                return msg.done and "Completed" or "In progress..."
              end
            end
          }
        },
      },
    },

    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",
  },
  config = function()
    local utils = require("custom.utils")

    -- Diagnostic keymaps
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({ float = false }) end,
      { desc = "Go to previous diagnostic message" }
    )
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({ float = false }) end,
      { desc = "Go to next diagnostic message" }
    )
    vim.keymap.set("n", "<leader>dm", vim.diagnostic.open_float, { desc = "Open floating [D]iagnostic [M]essage" })
    vim.keymap.set("n", "<leader>dl", vim.diagnostic.setqflist, { desc = "Open [D]iagnostics [L]ist" })

    -- [[ Configure LSP ]]
    -- This function gets run when an LSP connects to a particular buffer.
    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

      nmap("<leader>rl", function()
        print("Restarting LSP client...")
        vim.cmd(":LspRestart")
      end, "[R]estart [L]sp")
      nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      nmap("gd", function()
        require("telescope.builtin").lsp_definitions({ fname_width = 70 })
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
        require("telescope.builtin").lsp_implementations({ fname_width = 70 })
        utils.unfold()
      end, "[G]oto [I]mplementation")
      nmap("<leader>D", function()
        require("telescope.builtin").lsp_type_definitions({ fname_width = 70 })
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
          config.settings.python.pythonPath = utils.get_poetry_venv_executable_path("python", false, config.root_dir)
        end,
      },
      ruff_lsp = {
        init_options = {
          settings = {
            args = {
              -- Let pyright handle undefined symbols, unused variables, imports, commented out code
              "--ignore", "F821,F841,F401,ERA001"
            }
          }
        }
      },
      rust_analyzer = { settings = {} },
      tsserver = { settings = {} },
      html = { settings = {}, filetypes = { "html", "twig", "hbs" } },
      jsonls = { settings = {} },
      bashls = { settings = {} },
      solargraph = { settings = {} },

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
