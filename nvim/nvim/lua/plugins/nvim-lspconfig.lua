return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    {
      "williamboman/mason.nvim",
      commit = "0f6fea935578039a271cdb52a5fdfcc58474bc5d",
      opts = {
        ui = {
          border = "rounded"
        },
      }
    },
    {
      "williamboman/mason-lspconfig.nvim",
      commit = "1a31f824b9cd5bc6f342fc29e9a53b60d74af245"
    },
    "WhoIsSethDaniel/mason-tool-installer.nvim",
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
    local symbols = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.WARN] = "󰀪 "
    }
    local highlights = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticError",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    }

    -- Setup initial diagnostic config
    vim.diagnostic.config({
      virtual_lines = false,
      signs = {
        severity = vim.diagnostic.severity.ERROR,
        text = {
          [vim.diagnostic.severity.ERROR] = symbols[vim.diagnostic.severity.ERROR],
          [vim.diagnostic.severity.WARN] = symbols[vim.diagnostic.severity.WARN],
          [vim.diagnostic.severity.INFO] = symbols[vim.diagnostic.severity.INFO],
          [vim.diagnostic.severity.HINT] = symbols[vim.diagnostic.severity.HINT],
        },
        numhl = highlights
      },
      float = { source = true, border = border },
      severity_sort = true
    })

    -- Styling for floating windows
    require("lspconfig.ui.windows").default_options.border = border

    -- From :h diagnostic-handlers-example
    local ns = vim.api.nvim_create_namespace("my_namespace")

    -- Get a reference to the original signs handler
    local orig_signs_handler = vim.diagnostic.handlers.signs

    -- Override the built-in signs handler
    vim.diagnostic.handlers.signs = {
      show = function(_, bufnr, _, opts)
        -- Get all diagnostics from the whole buffer rather than just the
        -- diagnostics passed to the handler
        local diagnostics = vim.diagnostic.get(bufnr)

        -- Find the "worst" diagnostic per line
        local max_severity_per_line = {}
        for _, d in pairs(diagnostics) do
          local m = max_severity_per_line[d.lnum]
          if not m or d.severity < m.severity then
            max_severity_per_line[d.lnum] = d
          end
        end

        -- Pass the filtered diagnostics (with our custom namespace) to
        -- the original handler
        local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
        orig_signs_handler.show(ns, bufnr, filtered_diagnostics, opts)
      end,
      hide = function(_, bufnr)
        orig_signs_handler.hide(ns, bufnr)
      end,
    }

    -- Diagnostic keymaps
    vim.keymap.set("n", "<C-t>", function()
      local new_config = not vim.diagnostic.config().virtual_lines
      vim.diagnostic.config({ virtual_lines = new_config })
    end, { desc = "Toggle virtual lines" })
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, { desc = "Go to previous diagnostic message" })
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { desc = "Go to next diagnostic message" })
    vim.keymap.set("n", "<M-x>", function()
      local qf_exists = false
      for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
          qf_exists = true
        end
      end
      if qf_exists == true then
        vim.cmd "cclose"
        return
      end
      vim.diagnostic.setqflist()
    end, { desc = "Open diagnostics in quickfix list" })

    local pyright_diagnostic_mode = "openFilesOnly"
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        map("<C-w>gh", function()
          require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" })
        end, "[G]oto Definition In Vertical Split")
        map("<C-w>gs", function()
          require("telescope.builtin").lsp_definitions({ jump_type = "split" })
        end, "[G]oto Definition In [S]plit")
        map("<C-w>gt", function()
          require("telescope.builtin").lsp_definitions({ jump_type = "tab" })
        end, "[G]oto Definition In [T]ab")
        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        map("gO", require("telescope.builtin").lsp_outgoing_calls, "[G]oto [O]utgoing Calls")
        map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
        map("<leader>sW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[S]earch [W]orkspace Symbols")
        map("<leader>ss", function()
          local word = vim.fn.expand("<cword>")
          require("telescope.builtin").lsp_workspace_symbols({
            prompt_title = "LSP Workspace Symbols (" .. word .. ")",
            query = word,
          })
        end, "[S]earch [S]ymbol")
        map("<leader>sf", function()
          local word = vim.fn.expand("<cword>")
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].filetype == "python" then
            require("telescope.builtin").grep_string({
              prompt_title = "LSP Workspace Function Symbols (" .. word .. ")",
              search = "def " .. word
            })
          else
            require("telescope.builtin").lsp_workspace_symbols({
              prompt_title = "LSP Workspace Function Symbols (" .. word .. ")",
              query = word,
              symbols = { "function", "method" }
            })
          end
        end, "[S]earch [F]unction Symbol")

        -- See `:help K` for why this keymap
        map("K", function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover({ border = "rounded" })
          end
        end, "Hover Documentation")
        map("<leader>rl", function()
          utils.print("Restarting LSP client...")
          vim.cmd(":LspRestart")
        end, "[R]estart [L]sp")
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        map("<leader>K", function()
          vim.lsp.buf.signature_help()
        end, "Signature Documentation")

        -- Lesser used LSP functionality
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client then
          if client.name == "basedpyright" then
            ---@diagnostic disable-next-line: undefined-field
            client.settings.basedpyright.analysis.diagnosticMode = pyright_diagnostic_mode
            map("<leader>rd", function()
              if pyright_diagnostic_mode == "openFilesOnly" then
                pyright_diagnostic_mode = "workspace"
              else
                pyright_diagnostic_mode = "openFilesOnly"
              end
              vim.cmd(":LspRestart")
              utils.print("Restarting LSP with diagnosticMode=" .. pyright_diagnostic_mode)
            end, "Reset Diagnostic Mode")
          end

          -- Enable highlighting usages of the symbol under the cursor if the LSP server supports it
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- Enable inlay hints if the LSP server supports it
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
            end, "[T]oggle Inlay [H]ints")
          end
        end
      end
    })

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- Add foldingRange capabilities for nvim-ufo
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = false
    }

    -- Enable the following language servers
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
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              -- Ignore diagnostic output in files under these paths
              ignore = { "migrations/**", ".venv/**" },
              diagnosticMode = pyright_diagnostic_mode, -- can be "workspace" or "openFilesOnly"
              typeCheckingMode = "basic",               -- can be "off", "basic", "standard", "strict", "recommended" or "all"
              diagnosticSeverityOverrides = {
                reportMissingImports = true,
                reportMissingTypeStubs = false,
                reportUnusedImport = true,
              },
              useLibraryCodeForTypes = true
            },
          },
          python = {}
        },
        before_init = function(_, config)
          config.settings.python.pythonPath = utils.get_poetry_venv_executable_path("python", config.root_dir)
        end,
      },
      ruff = {
        settings = {
          organizeImports = true,
          fixAll = true,
          showSyntaxErrors = true,
          format = {
            preview = true
          },
          lint = {
            preview = false,
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
            diagnostics = { disable = { "missing-fields" } },
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

    -- mason-lspconfig requires that these setup functions are called in this order
    -- before setting up the servers.
    require("mason").setup()

    local ensure_installed = vim.tbl_keys(servers or {})
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    -- Ensure the servers above are installed
    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end
      }
    })
  end
}
