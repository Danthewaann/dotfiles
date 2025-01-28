return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  cmd = { "DiffviewOpen" },
  config = function()
    local actions = require("diffview.config").actions
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
            "<C-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<C-k>",
            function() actions.select_prev_entry() end,
            { desc = "Select previous entry" }
          },
          { "n", "h", false },
          { "n", "l", false },
        },
        file_history_panel = {
          {
            "n",
            "<C-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<C-k>",
            function() actions.select_prev_entry() end,
            { desc = "Select previous entry" }
          },
          { "n", "h", false },
          { "n", "l", false },
        },
        view = {
          {
            "n",
            "<C-j>",
            function() actions.select_next_entry() end,
            { desc = "Select next entry" }
          },
          {
            "n",
            "<C-k>",
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
            M.print_err(base_branch)
            return
          end

          vim.cmd(":DiffviewOpen origin/" .. base_branch .. "...HEAD --imply-local")
        end,
        ["3. View all file history "] = function()
          vim.cmd(":DiffviewFileHistory --max-count=10000")
        end,
        ["4. View current file history "] = function()
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
