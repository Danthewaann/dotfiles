return {
  "tpope/vim-fugitive",
  dependencies = { "tpope/vim-rhubarb" },
  config = function()
    local utils = require("custom.utils")
    vim.keymap.set("n", "<C-g>", function()
      local windows = vim.api.nvim_list_wins()
      for _, v in pairs(windows) do
        local status, _ = pcall(vim.api.nvim_win_get_var, v, "fugitive_status")
        if status then
          local ok, _ = pcall(vim.api.nvim_win_close, v, false)
          if ok then
            return
          end
        end
      end
      vim.cmd [[Git]]
    end, { desc = "[G]it Status" })

    local git_log_args =
    "--full-history --oneline --decorate --pretty=format:'%C(auto)%h%d%Creset %C(cyan)(%cr)%Creset %s'"

    vim.keymap.set("n", "<leader>gla", string.format("<cmd> tab Git log %s<CR>", git_log_args),
      { desc = "[G]it [L]og [A]ll" })
    vim.keymap.set("n", "<leader>glA", "<cmd>Gclog<CR>", { desc = "[G]it [L]og [A]ll in quickfix list" })
    vim.keymap.set("n", "<leader>glf", function()
      vim.cmd(string.format("Git log %s --follow %%", git_log_args))
    end, { desc = "[G]it [L]og current [F]ile" })
    vim.keymap.set("n", "<leader>glF", "<cmd>0Gclog<CR>", { desc = "[G]it [L]og current [F]ile in quickfix list" })
    vim.keymap.set("x", "<leader>gl", function()
      vim.cmd([[ execute "normal! \<ESC>" ]])
      local start_pos = vim.api.nvim_buf_get_mark(0, "<")[1]
      local end_pos = vim.api.nvim_buf_get_mark(0, ">")[1]
      vim.cmd(string.format("Git log %s --no-patch -L %s,%s:%%", git_log_args, start_pos, end_pos))
    end, { desc = "[G]it [L]og current selection" })
    vim.keymap.set("v", "<leader>gL", ":Gclog<CR>",
      { desc = "[G]it [L]og current selection in quickfix list", silent = true })
    vim.keymap.set({ "n", "v" }, "<leader>gb", ":Git blame<CR>", { desc = "[G]it [B]lame", silent = true })
    vim.keymap.set("n", "<leader>gc", function()
      vim.system({ "git", "jump", "--stdout", "merge" }, {}, function(obj)
        vim.schedule(function()
          if obj.code > 1 then
            utils.print_err(vim.fn.trim(obj.stderr))
            return
          end
          local qf_entries = {}
          for line in obj.stdout:gmatch("[^\r\n]+") do
            local filename, lnum, text = line:match("([^:]+):(%d+):%s*(.+)")
            if filename and lnum and text then
              table.insert(qf_entries, {
                filename = filename,
                lnum = tonumber(lnum),
                col = 0,
                text = text,
              })
            end
          end
          vim.fn.setqflist({}, " ", { title = "Git conflicts", items = qf_entries })
          vim.cmd("copen")
        end)
      end)
    end, { desc = "[G]it [C]onflicts" })

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
        vim.keymap.set("n", "gl", "<cmd> vertical Git log --oneline --full-history<CR>",
          { buffer = buf, desc = "Git log" })
        vim.keymap.set("n", "p", "<nop>", { buffer = buf })
        vim.keymap.set("n", "pp", "<cmd> Git push<CR>", { buffer = buf, desc = "Git push" })
        vim.keymap.set("n", "pf", "<cmd> Git push --force<CR>", { buffer = buf, desc = "Git push --force" })
        vim.keymap.set("n", "Pp", "<cmd> Git pull<CR>", { buffer = buf, desc = "Git pull" })
        vim.keymap.set("n", "S", "<cmd> Git add .<CR>", { buffer = buf, desc = "Git add all" })
      end
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("gitcommit_startinsert", { clear = true }),
      pattern = "gitcommit",
      callback = function()
        if #vim.fn.getline(".") == 0 then
          vim.cmd.startinsert()
        end
      end
    })
  end
}
