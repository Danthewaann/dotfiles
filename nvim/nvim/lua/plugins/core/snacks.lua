local git_opts = {
  ---@type snacks.picker.Action.fn
  confirm = function(picker, item)
    local commit_hash = item.commit
    picker:close()
    vim.api.nvim_command(":Gedit " .. commit_hash)
  end,
  actions = {
    ["copy_commit_hash"] = function(_, item)
      local commit_hash = item.commit
      local utils = require("custom.utils")
      utils.print("Copied commit hash " .. commit_hash .. " to clipboard")

      vim.fn.setreg("+", commit_hash)
      vim.fn.setreg("*", commit_hash)
    end,
    ["open_pr_in_browser"] = function(_, item)
      local msg = item.msg
      local pr_number = tonumber(
        msg:match("%(#(%d+)%)%s*$")
      )
      if pr_number ~= nil then
        vim.cmd(":Browse (#" .. pr_number .. ")")
      end
    end
  },
  win = {
    input = {
      keys = {
        ["<c-y>"] = { "copy_commit_hash", mode = { "i", "n" } },
        ["o"] = { "open_pr_in_browser", mode = { "n" } }
      }
    }
  },
}

return {
  "folke/snacks.nvim",
  priority = 1000,
  enabled = true,
  lazy = false,
  ---@type snacks.Config
  opts = {
    win = {
      backdrop = {
        bg = "#1a1d21",
        blend = 40,
      },
    },
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = true },
    indent = { enabled = false },
    input = { enabled = true },
    picker = {
      win = {
        input = {
          keys = {
            ["<c-s>"] = false,
            ["<c-x>"] = { "edit_split", mode = { "i", "n" } },
            ["<c-h>"] = { "toggle_help_input", mode = "i" },
            ["<c-o>"] = { "toggle_preview", mode = { "i", "n" } },
            ["<M-o>"] = { "toggle_maximize", mode = { "i", "n" } },
            ["<c-e>"] = { "cycle_win", mode = { "i", "n" } },
            ["<M-e>"] = { "toggle_focus", mode = { "i", "n" } },
          }
        },
        list = {
          keys = {
            ["<c-s>"] = false,
            ["<c-x>"] = { "edit_split", mode = { "i", "n" } },
            ["<c-h>"] = { "toggle_help_input", mode = "i" },
            ["<c-o>"] = { "toggle_preview", mode = { "i", "n" } },
            ["<M-o>"] = { "toggle_maximize", mode = { "i", "n" } },
            ["<c-e>"] = { "cycle_win", mode = { "i", "n" } },
            ["<M-e>"] = { "toggle_focus", mode = { "i", "n" } },
          }
        },
      },
      layout = "my_default_layout",
      layouts = {
        my_default_layout = {
          fullscreen = true,
          layout = {
            box = "vertical",
            backdrop = false,
            row = -1,
            width = 0,
            height = 0.4,
            border = "top",
            title = " {title} {live} {flags}",
            title_pos = "left",
            { win = "input", height = 1, border = "bottom" },
            {
              box = "horizontal",
              { win = "list",    border = "none" },
              { win = "preview", title = "{preview}", width = 0.6, border = "left" },
            },
          }
        },
      },
    },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = false },
    scroll = { enabled = false },
    statuscolumn = { enabled = false },
    words = { enabled = false },
  },
  keys = {
    -- core
    { "<leader>s/", function() Snacks.picker.search_history() end,             desc = "Search History" },
    { "<leader>:",  function() Snacks.picker.command_history() end,            desc = "Command History" },
    { "<leader>n",  function() Snacks.picker.notifications() end,              desc = "Notification History" },
    { "<leader>e",  function() Snacks.explorer() end,                          desc = "File Explorer" },
    { "<leader>B",  function() Snacks.picker.pick() end,                       desc = "Builtin" },
    -- find
    { "<C-f>",      function() Snacks.picker.files({ hidden = true }) end,     desc = "Find Files" },
    { "<C-p>",      function() Snacks.picker.git_files() end,                  desc = "Find Git Files" },
    { "<leader>,",  function() Snacks.picker.buffers() end,                    desc = "Buffers" },
    { "<leader>.",  function() Snacks.picker.recent() end,                     desc = "Recent" },
    { "<leader>S",  function() Snacks.picker.smart() end,                      desc = "Smart Find Files" },
    -- main search
    { "<leader>sb", function() Snacks.picker.lines() end,                      desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end,               desc = "Grep Open Buffers" },
    { "<leader>/",  function() Snacks.picker.grep({ hidden = true }) end,      desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word({ hidden = true }) end, desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>si", function() Snacks.picker.icons() end,                      desc = "Icons" },
    {
      "<leader>sd",
      function()
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].filetype == "diff" or vim.bo[buf].filetype == "git" then
          Snacks.picker.lines()
          vim.schedule(function()
            vim.api.nvim_feedkeys("^diff --git ", "i", false)
          end)
          return
        end
        require("aerial").snacks_picker()
      end,
      desc = "Document Symbols"
    },
    { "<leader>sx", function() Snacks.picker.diagnostics_buffer() end,           desc = "Buffer Diagnostics" },
    { "<leader>sX", function() Snacks.picker.diagnostics() end,                  desc = "Diagnostics" },
    { "<leader>sq", function() Snacks.picker.qflist() end,                       desc = "Quickfix List" },
    { "<leader>sh", function() Snacks.picker.help() end,                         desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end,                   desc = "Highlights" },
    { "<leader>sr", function() Snacks.picker.resume() end,                       desc = "Resume" },
    -- other search
    { '<leader>s"', function() Snacks.picker.registers() end,                    desc = "Registers" },
    { "<leader>sa", function() Snacks.picker.autocmds() end,                     desc = "Autocmds" },
    { "<leader>sj", function() Snacks.picker.jumps() end,                        desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end,                      desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end,                      desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end,                        desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end,                          desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end,                         desc = "Search for Plugin Spec" },
    { "<leader>su", function() Snacks.picker.undo() end,                         desc = "Undo History" },
    -- git
    { "<leader>gs", function() Snacks.picker.git_status() end,                   desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end,                    desc = "Git Stash" },
    { "<leader>gb", function() Snacks.picker.git_branches() end,                 desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log(git_opts) end,              desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line(git_opts) end,         desc = "Git Log Line" },
    { "<leader>gf", function() Snacks.picker.git_log_file(git_opts) end,         desc = "Git Log File" },
    -- gh
    { "<leader>gi", function() Snacks.picker.gh_issue() end,                     desc = "GitHub Issues (open)" },
    { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end,    desc = "GitHub Issues (all)" },
    { "<leader>gp", function() Snacks.picker.gh_pr() end,                        desc = "GitHub Pull Requests (open)" },
    { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end,       desc = "GitHub Pull Requests (all)" },
    -- LSP
    { "gd",         function() Snacks.picker.lsp_definitions() end,              desc = "Goto Definition" },
    { "gD",         function() Snacks.picker.lsp_declarations() end,             desc = "Goto Declaration" },
    { "gr",         function() Snacks.picker.lsp_references() end,               nowait = true,                       desc = "References" },
    { "gI",         function() Snacks.picker.lsp_implementations() end,          desc = "Goto Implementation" },
    { "gy",         function() Snacks.picker.lsp_type_definitions() end,         desc = "Goto T[y]pe Definition" },
    { "gai",        function() Snacks.picker.lsp_incoming_calls() end,           desc = "C[a]lls Incoming" },
    { "gao",        function() Snacks.picker.lsp_outgoing_calls() end,           desc = "C[a]lls Outgoing" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end,                  desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end,        desc = "LSP Workspace Symbols" },
    -- Other
    { "<leader>z",  function() Snacks.zen({ win = { border = "rounded" } }) end, desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end,                            desc = "Toggle Zoom" },
    { "<leader>n",  function() Snacks.notifier.show_history() end,               desc = "Notification History" },
    { "<leader>bD", function() Snacks.bufdelete() end,                           desc = "Delete Buffer" },
    { "<leader>rf", function() Snacks.rename.rename_file() end,                  desc = "Rename File" },
    { "<leader>un", function() Snacks.notifier.hide() end,                       desc = "Dismiss All Notifications" },
  },
  init = function()
    vim.g.snacks_animate = false
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        -- Override print to use snacks for `:=` command
        if vim.fn.has("nvim-0.11") == 1 then
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = _G.dd
        end

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("list", { name = "List" }):map("<leader>ui")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.option("conceallevel",
          { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
          "<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.indent():map("<leader>ug")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
