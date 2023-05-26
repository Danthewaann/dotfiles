-- local lsp = require('lsp-zero').preset({ name = 'recommended' })

-- lsp.on_attach(function(client, bufnr)
-- 	lsp.default_keymaps({buffer = bufnr})
-- end)

-- -- When you don't have mason.nvim installed
-- -- You'll need to list the servers installed in your system
-- lsp.ensure_installed({'pyright'})

-- -- (Optional) Configure lua language server for neovim
-- require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
-- require("lspconfig").pyright.setup({})

-- lsp.set_sign_icons({
-- 	error = '',
-- 	warn = '',
-- 	hint = '',
-- 	info = ''
-- })

-- lsp.setup()
