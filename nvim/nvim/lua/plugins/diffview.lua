return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DV" },
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

    vim.api.nvim_create_user_command("DV", function(opts)
      local arg = opts.args

      if opts.count ~= -1 then
        vim.cmd(":" .. opts.line1 .. "," .. opts.line2 .. "DiffviewFileHistory --max-count=10000")
      elseif arg == "" then
        vim.cmd(":DiffviewOpen")
      elseif arg == "origin" then
        local base_branch = vim.fn.trim(vim.fn.system("git-get-base-branch"))
        if vim.v.shell_error ~= 0 then
          utils.print_err(base_branch)
          return
        end
        vim.cmd(":DiffviewOpen origin/" .. base_branch .. "...HEAD --imply-local")
      elseif arg == "raw" then
        vim.cmd("new git diff | read! git diff")
        vim.cmd("set filetype=diff | only | normal ggdd")
        local buf = vim.api.nvim_get_current_buf()
        vim.bo[buf].modified = false
        vim.bo[buf].modifiable = false
        vim.bo[buf].buflisted = false
      elseif arg == "raw-origin" then
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
      elseif arg == "file-history" then
        vim.cmd(":DiffviewFileHistory --max-count=10000")
      elseif arg == "cur-file-history" then
        vim.cmd(":DiffviewFileHistory  --max-count=10000 %")
      end
    end, {
      nargs = "?",
      range = true,
      desc = "View various project, buffer and selection diffs",
      complete = function()
        return { "origin", "raw", "raw-origin", "file-history", "cur-file-history" }
      end
    })
  end,
}
