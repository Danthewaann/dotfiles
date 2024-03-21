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
    -- Extra signature help
    "ray-x/lsp_signature.nvim",

    -- Useful status updates for LSP
    { "j-hui/fidget.nvim", opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    "folke/neodev.nvim",
  },
  config = function()
    local utils = require("custom.utils")
    local show_virtual_text = true

    -- Setup initial diagnostic config
    vim.diagnostic.config({
      virtual_text = show_virtual_text,
      float = { source = "always" },
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

    -- Diagnostic keymaps
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
    vim.keymap.set("n", "<leader>o", vim.diagnostic.setqflist, { desc = "Open diagnostics in quickfix list" })
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show floating diagnostic message" })

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
        utils.print("Restarting LSP client...")
        vim.cmd(":LspRestart")
      end, "[R]estart [L]sp")
      nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

      nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
      nmap("gh", function()
        -- Workaround: https://github.com/nvim-telescope/telescope.nvim/issues/2368
        vim.cmd(":vsplit | lua vim.lsp.buf.definition()")
      end, "[G]oto Definition In Vertical Split")
      nmap("gs", function()
        vim.cmd(":split | lua vim.lsp.buf.definition()")
      end, "[G]oto Definition In [S]plit")
      nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
      nmap("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
      nmap("gO", require("telescope.builtin").lsp_outgoing_calls, "[G]oto [O]utgoing Calls")
      nmap("gI", require("telescope.builtin").lsp_incoming_calls, "[G]oto [I]ncoming Calls")
      nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
      nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
      nmap("<leader>sa", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[S]earch [A]ll Workspace Symbols")
      nmap("<leader>ss", function()
        local word = vim.fn.expand("<cword>")
        require("telescope.builtin").lsp_workspace_symbols({
          prompt_title = "LSP Workspace Symbols (" .. word .. ")",
          query = word,
        })
      end, "[S]earch Current Workspace [S]ymbol")
      nmap("<leader>sf", function()
        local word = vim.fn.expand("<cword>")
        require("telescope.builtin").lsp_workspace_symbols({
          prompt_title = "LSP Workspace Function Symbols (" .. word .. ")",
          query = word,
          symbols = { "function", "method" }
        })
      end, "[S]earch Current Workspace [F]unction symbols")

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
        utils.print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
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
      gopls = {
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = true,
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
              typeCheckingMode = "basic",
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
      ruff_lsp = {
        init_options = {
          settings = {
            args = {
              -- Let pyright handle the following errors
              "--ignore",
              table.concat({
                "F821",   -- undefined symbols
                "F841",   -- unused variables
                "F401",   -- imports
                "ERA001", -- commented out code
                "E999",   -- syntax errors
              }, ",")
            }
          }
        }
      },
      rust_analyzer = { settings = {} },
      tsserver = { settings = {} },
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
      vimls = { settings = {} }
    }

    -- Setup neovim lua configuration
    require("neodev").setup()

    -- Styling for floating windows
    local border = "rounded"
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
    vim.diagnostic.config({ float = { border = border } })
    require("lspconfig.ui.windows").default_options.border = border

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

    require("lsp_signature").setup({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      },
      padding = "  ",
      fix_pos = true,
      max_width = vim.o.columns,
      hint_enable = false,
      hint_prefix = "",
      floating_window = true,
      doc_lines = 0,
    })
  end
}
