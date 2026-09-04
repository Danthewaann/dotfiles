return {
  "tpope/vim-fugitive",
  dependencies = {
    "tpope/vim-rhubarb",
    {
      "barrettruth/diffs.nvim",
      init = function()
        vim.g.diffs = {
          integrations = {
            fugitive = true,
            gitsigns = true,
          },
          extra_filetypes = { "snacks_picker_preview" },
          highlights = {
            warn_max_lines = false,
            treesitter = { max_lines = 1000 },
            vim = { max_lines = 500 },
          },
        }
        vim.keymap.set("n", "<leader>co", "<Plug>(diffs-conflict-ours)", { desc = "[C]onflict ours" })
        vim.keymap.set("n", "<leader>ct", "<Plug>(diffs-conflict-theirs)", { desc = "[C]onflict theirs" })
        vim.keymap.set("n", "<leader>cb", "<Plug>(diffs-conflict-both)", { desc = "[C]onflict both" })
        vim.keymap.set("n", "<leader>c0", "<Plug>(diffs-conflict-none)", { desc = "[C]onflict none" })
        vim.keymap.set("n", "]x", "<Plug>(diffs-conflict-next)", { desc = "Next conflict" })
        vim.keymap.set("n", "[x", "<Plug>(diffs-conflict-prev)", { desc = "Previous conflict" })
      end,
      dependencies = { "lewis6991/gitsigns.nvim" }
    }
  },
  config = function()
    local utils = require("custom.utils")
    vim.keymap.set("n", "<C-g>", function()
      local windows = vim.api.nvim_list_wins()
      for _, win in pairs(windows) do
        local status, _ = pcall(vim.api.nvim_win_get_var, win, "fugitive_status")
        if status then
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "fugitive" then
            local ok, _ = pcall(vim.api.nvim_win_close, win, true)
            if not ok then
              utils.print_err("Cannot close fugitive as it is the last window")
            end
            return
          end
        end
      end
      vim.cmd [[Git]]
    end, { desc = "[G]it Status" })

    vim.keymap.set({ "n", "v" }, "<leader>gB", ":Git blame<CR>", { desc = "[G]it [B]lame", silent = true })
    vim.keymap.set("n", "<leader>gx", function()
      local cmd = { "git", "jump", "--stdout", "merge" }
      vim.system(cmd, {}, function(obj)
        vim.schedule(function()
          if obj.code > 1 then
            utils.handle_system_err("git jump", cmd, obj)
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
    end, { desc = "[G]it Conflicts" })

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
        vim.keymap.set("n", "cc", function()
          if utils.file_exists(".gittemplate") then
            local f, err = io.open(".gittemplate", "r")
            if err then
              utils.print_err(err)
              return
            end

            assert(f)
            local message = vim.fn.trim(f:read("*a"))
            local cmd = string.format(":Git commit -m \"%s\"", message)
            vim.cmd(cmd)
          else
            vim.cmd(":Git commit")
          end
        end, { buffer = buf, desc = "Git add all" })
      end
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("gitcommit_startinsert", { clear = true }),
      pattern = "gitcommit",
      callback = function(event)
        local buf = event.buf
        vim.keymap.set("n", "gl", "<cmd> vertical Git log --oneline --full-history<CR>",
          { buffer = buf, desc = "Git log" })
        if #vim.fn.getline(".") == 0 then
          vim.cmd.startinsert()
        end
      end
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("git_binds", { clear = true }),
      pattern = "git",
      callback = function(event)
        local buf = event.buf
        vim.keymap.set("n", "}", "]/", { remap = true, buffer = buf, desc = "Next file" })
        vim.keymap.set("n", "{", "[/", { remap = true, buffer = buf, desc = "Previous file" })
        vim.keymap.set("n", "X", ".Git reset<C-e>^<CR>",
          { remap = true, silent = true, buffer = buf, desc = "Reset commit under cursor" })
      end
    })
  end
}
