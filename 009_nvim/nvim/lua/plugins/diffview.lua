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
          }
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
          }
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
      vim.ui.select(
        { "Diff working tree against HEAD", "Diff HEAD against origin merge base", "Custom" },
        { prompt = "Choose Diffview" },
        function(choice)
          if choice == "Diff working tree against HEAD" then
            vim.cmd(":DiffviewOpen")
          elseif choice == "Diff HEAD against origin merge base" then
            local base_branch = vim.fn.trim(vim.fn.system("git-get-base-branch"))
            if vim.v.shell_error ~= 0 then
              M.print_err(base_branch)
              return
            end

            vim.cmd(":DiffviewOpen origin/" .. base_branch .. "...HEAD")
          elseif choice == "Custom" then
            vim.ui.input(
            { prompt = "Enter DiffviewOpen arguments" },
              function(input)
                if input ~= nil then
                  vim.cmd(":DiffviewOpen " .. input)
                end
              end)
          end
        end
      )
    end, {
      desc = "[D]iff [V]iew",
    })
    vim.keymap.set("n", "<leader>gla", ":DiffviewFileHistory<CR>", {
      silent = true,
      desc = "[G]it [L]og [A]ll"
    })
    vim.keymap.set("n", "<leader>glf", ":DiffviewFileHistory %<CR>", {
      silent = true,
      desc = "[G]it [L]og [F]ile"
    })
    vim.keymap.set("x", "<leader>gl", ":DiffviewFileHistory<CR>", {
      silent = true,
      desc = "[G]it [L]og for selection"
    })
  end,
}
