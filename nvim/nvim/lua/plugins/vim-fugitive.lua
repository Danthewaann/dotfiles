return {
  "tpope/vim-fugitive",
  dependencies = { "tpope/vim-rhubarb" },
  config = function()
    vim.keymap.set("n", "<C-g>", "<cmd> Git<CR>", { desc = "Git status" })

    local git_log_args = "--full-history --oneline --decorate --pretty=format:'%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %s'"

    vim.keymap.set("n", "<leader>gla", string.format("<cmd> Git log %s<CR>", git_log_args),
      { desc = "[G]it [L]og [A]ll" })
    vim.keymap.set("n", "<leader>glA", "<cmd>Gclog<CR>", { desc = "[G]it [L]og [A]ll in quickfix list" })
    vim.keymap.set("n", "<leader>glf", function()
      vim.cmd(string.format("Git log %s %s", git_log_args, vim.fn.expand("%")))
    end, { desc = "[G]it [L]og current [F]ile" })
    vim.keymap.set("n", "<leader>glF", "<cmd>0Gclog<CR>", { desc = "[G]it [L]og current [F]ile in quickfix list" })
    vim.keymap.set("x", "<leader>gl", function()
      vim.cmd([[ execute "normal! \<ESC>" ]])
      local start_pos = vim.api.nvim_buf_get_mark(0, "<")[1]
      local end_pos = vim.api.nvim_buf_get_mark(0, ">")[1]
      vim.cmd(string.format("Git log %s --no-patch -L %s,%s:%s", git_log_args, start_pos, end_pos, vim.fn.expand("%")))
    end, { desc = "[G]it [L]og current selection" })
    vim.keymap.set("v", "<leader>gL", ":Gclog<CR>",
      { desc = "[G]it [L]og current selection in quickfix list", silent = true })

    vim.keymap.set({ "n", "v" }, "<leader>gy", ":GBrowse!<CR>",
      { desc = "[G]it [Y]ank link to clipboard", silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>go", ":GBrowse<CR>", { desc = "[G]it [O]pen link in browser", silent = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("fugitive_binds", { clear = true }),
      pattern = "fugitive",
      callback = function(event)
        local buf = event.buf
        vim.opt_local.signcolumn = "no"
        vim.keymap.set("n", "<Tab>", function() vim.fn.feedkeys("=") end, { buffer = buf })
        vim.keymap.set("n", "pp", "<cmd> Git push<CR>", { buffer = buf, desc = "Git push" })
        vim.keymap.set("n", "pf", "<cmd> Git push --force<CR>", { buffer = buf, desc = "Git push --force" })
        vim.keymap.set("n", "Pp", "<cmd> Git pull<CR>", { buffer = buf, desc = "Git pull" })
      end
    })
  end
}
