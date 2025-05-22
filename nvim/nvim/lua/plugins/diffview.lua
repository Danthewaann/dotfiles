return {
  "sindrets/diffview.nvim",
  keys = {
    { "<leader>dv", desc = "[D]iff [V]iew" }
  },
  cmd = { "DiffviewOpen" },
  config = function()
    local actions = require("diffview.config").actions
    local utils = require("custom.utils")
    require("diffview").setup({
      file_panel = {
        listing_style = "list",
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {},
        },
      },
      keymaps = {
        file_panel = {
          {
            "n",
            "<M-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<M-k>",
            function() actions.select_prev_entry() end,
            { desc = "Select previous entry" }
          },
          { "n", "h", false },
          { "n", "l", false },
        },
        file_history_panel = {
          {
            "n",
            "<M-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<M-k>",
            function() actions.select_prev_entry() end,
            { desc = "Select previous entry" }
          },
          { "n", "h", false },
          { "n", "l", false },
        },
        view = {
          {
            "n",
            "<M-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<M-k>",
            function() actions.select_prev_entry() end,
            { desc = "Select previous entry" }
          }
        }
      }
    })

    vim.keymap.set("n", "<leader>dv", function()
      local commands = {
        ["1. Diff working tree against HEAD"] = function()
          vim.cmd(":DiffviewOpen")
        end,
        ["2. Diff HEAD against origin merge base"] = function()
          local base_branch = vim.fn.trim(vim.fn.system("git-get-base-branch"))
          if vim.v.shell_error ~= 0 then
            utils.print_err(base_branch)
            return
          end

          vim.cmd(":DiffviewOpen origin/" .. base_branch .. "...HEAD --imply-local")
        end,
        ["3. RAW diff working tree against HEAD"] = function()
          vim.cmd("new git diff | read! git diff")
          vim.cmd("set filetype=diff | only | normal ggdd")
          local buf = vim.api.nvim_get_current_buf()
          vim.bo[buf].modified = false
          vim.bo[buf].modifiable = false
          vim.bo[buf].buflisted = false
        end,
        ["4. RAW diff HEAD against origin merge base"] = function()
          local obj = vim.system({ "git-get-base-branch" }):wait()
          if obj.code ~= 0 then
            utils.print_err(vim.fn.trim(obj.stderr))
            return
          end
          local base_branch = vim.fn.trim(obj.stdout)
          vim.cmd("new git diff " .. base_branch .. " | read! git diff " .. base_branch)
          vim.cmd("set filetype=diff | only | normal ggdd")
          local buf = vim.api.nvim_get_current_buf()
          vim.bo[buf].modified = false
          vim.bo[buf].modifiable = false
          vim.bo[buf].buflisted = false
        end,
        ["5. View all file history "] = function()
          vim.cmd(":DiffviewFileHistory --max-count=10000")
        end,
        ["6. View current file history "] = function()
          vim.cmd(":DiffviewFileHistory  --max-count=10000 %")
        end,
      }

      local keys = vim.tbl_keys(commands)
      table.sort(keys)

      vim.ui.select(
        keys,
        { prompt = "Choose Diffview" },
        function(choice)
          for key, value in pairs(commands) do
            if choice == key then
              value()
              return
            end
          end
        end
      )
    end, {
      desc = "[D]iff [V]iew",
    })
    vim.keymap.set("x", "<leader>dv", ":DiffviewFileHistory --max-count=10000<CR>", {
      silent = true,
      desc = "[D]iff [V]iew file history for selection"
    })
  end,
}
