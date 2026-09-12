local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local utils = require("custom.utils")

autocmd("LspAttach", {
  group = augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- See `:help K` for why this keymap
    map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover Documentation")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", function()
      vim.lsp.buf.code_action({
        filter = function(x)
          -- Filter out the following code actions as I never use them:
          --   Ruff: Fix all auto-fixable problems
          --   Ruff: Organize imports
          if x.kind == "source.fixAll.ruff" or x.kind == "source.organizeImports.ruff" then
            return false
          end
          return true
        end
      })
    end, "[C]ode [A]ction")
    map("<leader>cl", function() vim.lsp.codelens.run() end, "[C]ode [L]ens")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation", "i")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      if not vim.tbl_contains({ "lua_ls", "rust_analyzer" }, client.name) then
        vim.lsp.codelens.enable(true, { bufnr = event.buf })
      end
      -- Enable highlighting usages of the symbol under the cursor if the LSP server supports it
      if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
    end
  end
})

autocmd("TermOpen", {
  group = augroup("terminal-settings", { clear = true }),
  pattern = "*",
  callback = function()
    vim.cmd(":setlocal number")

    -- Jump between prompts in the terminal
    vim.keymap.set({ "n", "x", "o" }, "{", [[?^\(.*\| \)\$ .*$<CR>:nohlsearch<CR>]], { buffer = 0, silent = true })
    vim.keymap.set({ "n", "x", "o" }, "}", [[/^\(.*\| \)\$ .*$<CR>:nohlsearch<CR>]], { buffer = 0, silent = true })

    local function jump_to_file(tab)
      -- Get the current sequence of non-blank characters
      if vim.fn.mode() == "n" then
        vim.cmd(":normal viW")
      end

      local selection = utils.get_visual_selection()

      -- If this is a normal path then just use normal `gf` functionality.
      -- pytest nodes contain `::` so they need special handling below.
      if not string.find(selection, "::") then
        if tab then
          vim.cmd(":wincmd gF")
        else
          vim.cmd(":normal gF")
        end
        return
      end

      local cmd = { "pytest-node-path", selection }
      local obj = vim.system(cmd):wait()
      if obj.code ~= 0 then
        utils.handle_system_err("pytest-node-path", cmd, obj)
        return
      end

      -- Separate the path from the line number
      -- e.g. some/path/to/file:42:
      --      ^ path            ^ line number
      local output = vim.fn.trim(obj.stdout)
      local parts = {}
      for str in string.gmatch(output, "([^:]*)") do
        if str ~= "" then
          parts[#parts + 1] = str
        end
      end

      local file = parts[1]
      local lnum = tonumber(parts[2])
      if tab then
        vim.cmd((":tabnew +%d %s"):format(lnum, file))
      else
        vim.cmd(":wincmd k")
        vim.cmd((":e +%d %s"):format(lnum, file))
      end
    end

    -- For a running terminal emulator that contains file paths that I would like to jump to in another buffer
    vim.keymap.set({ "n", "x" }, "gf", function() jump_to_file(false) end, { buffer = 0, silent = true })
    vim.keymap.set({ "n", "x" }, "<C-w>gf", function() jump_to_file(true) end, { buffer = 0, silent = true })
  end,
})

-- Disable highlighting for sql files.
-- treesitter will handle syntax highlighting if the file isn't too large in size
autocmd("BufEnter", {
  group = augroup("disable-sql-syntax", { clear = true }),
  pattern = "*.sql",
  command = "setlocal syntax=off",
})

-- Turn on spell checking in markdown, octo and git commit buffers
autocmd("FileType", {
  group = augroup("spell-checking", { clear = true }),
  pattern = { "markdown", "octo", "gitcommit" },
  command = "setlocal spell spelllang=en_us,en_gb"
})

-- Enable soft wrapping of lines in markdown and octo buffers
autocmd("FileType", {
  group = augroup("soft-wrap", { clear = true }),
  pattern = { "markdown", "octo" },
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.breakindent = true
    vim.wo.showbreak = "=> "
  end,
})

-- Disable `render-markdown` in LSP hover documentation windows and spell checking
autocmd("FileType", {
  group = augroup("disable-markdown-rendering", { clear = true }),
  pattern = "markdown",
  callback = function(event)
    if vim.bo[event.buf].buftype == "nofile" then
      local status, module = pcall(require, "render-markdown")
      if status then
        module.disable()
      end
      vim.o.spell = false
    end
  end
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("YankHighlight", { clear = true }),
  pattern = "*",
  callback = function()
    vim.hl.on_yank({ higroup = "Yank" })
  end,
})

-- Jump to the last position in the file
autocmd("BufReadPost", {
  group = augroup("jump-to-last-position", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd(":normal! g`\"")
    end
  end,
})

-- Some binds for navigating diffs
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("diff_binds", { clear = true }),
  pattern = { "diff", "git" },
  callback = function(event)
    local buf = event.buf
    vim.keymap.set("n", "}", "/diff --git<CR>zt", { silent = true, buffer = buf, desc = "Next file" })
    vim.keymap.set("n", "{", "?diff --git<CR>zt", { silent = true, buffer = buf, desc = "Previous file" })
  end
})
