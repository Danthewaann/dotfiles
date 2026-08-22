return {
  "nvim-telescope/telescope.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    "fdschmidt93/telescope-egrepify.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-symbols.nvim",
  },
  config = function()
    require("telescope").setup({
      defaults = {
        -- Cache the last 10 pickers so I can resume them later
        wrap_results = false,
        cache_picker = {
          num_pickers = 10,
          limit_entries = 1000,
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
        path_display = { "filename_first" },
        results_title = false,
        layout_strategy = "bottom_pane",
        winblend = 10,
        layout_config = {
          center = {
            anchor = "S",
            anchor_padding = 0,
            height = 0.30,
            width = { padding = 0 },
            mirror = true,
          },
          height = { padding = 0 },
          width = { padding = 0 }
        },
        sorting_strategy = "ascending",
        border = true,
        borderchars = {
          prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
          results = { " " },
          preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },
        mappings = {
          ["i"] = {
            ["<C-space>"] = "to_fuzzy_refine",
            ["<C-o>"] = require("telescope.actions.layout").toggle_preview,
            ["<C-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
            ["<C-e>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist
          }
        }
      },
      pickers = {
        lsp_workspace_symbols = {
          fname_width = 0.4,
          symbol_width = 0.4,
          symbol_type_width = 0.1
        },
        lsp_dynamic_workspace_symbols = {
          fname_width = 0.4,
          symbol_width = 0.4,
          symbol_type_width = 0.1
        },
        lsp_references = {
          include_declaration = false,
          include_current_line = true,
        },
        current_buffer_fuzzy_find = {
          previewer = false
        },
        buffers = {
          previewer = true,
          sort_mru = true,
          ignore_current_buffer = true
        },
        find_files = {
          previewer = true,
          hidden = true,
          no_ignore = false,
        },
        man_pages = { previewer = false },
        diagnostics = {
          sort_by = "severity",
          previewer = false
        },
        grep_string = {
          previewer = false,
          additional_args = {}
        },
        live_grep = {
          previewer = false,
          additional_args = {}
        },
      },
      extensions = {
        aerial = {
          -- Set the width of the first two columns (the second
          -- is relevant only when show_columns is set to 'both')
          col1_width = 4,
          col2_width = 80,
          -- Available modes: symbols, lines, both
          show_columns = "symbols",
        },
        fzf = {},
        egrepify = {
          -- Don't highlight search results
          results_ts_hl = false,
          previewer = false,
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({ layout_strategy = "cursor" })
        },
      }
    })

    local utils = require("custom.utils")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- Enable telescope extensions, if installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "aerial")
    pcall(require("telescope").load_extension, "egrepify")
    pcall(require("telescope").load_extension, "ui-select")

    -- Core
    vim.keymap.set("n", "<leader>/", require("telescope.builtin").search_history, { desc = "Search History" })
    vim.keymap.set("n", "<leader>:", require("telescope.builtin").command_history, { desc = "Search Command History" })
    vim.keymap.set("n", "<leader>B", require("telescope.builtin").builtin, { desc = "Search [B]uiltin Telescope" })

    -- Find
    vim.keymap.set("n", "<C-f>", require("telescope.builtin").find_files, { desc = "Files" })
    vim.keymap.set("n", "<C-p>", require("telescope.builtin").git_files, { desc = "Git Files" })
    vim.keymap.set("n", "<leader>,", require("telescope.builtin").buffers, { desc = "Open Buffers" })
    vim.keymap.set("n", "<leader>.", function()
      require("telescope.builtin").oldfiles({ only_cwd = true })
    end, { desc = "Oldfiles" })

    -- Search
    vim.keymap.set("n", "<leader>sb", require("telescope.builtin").current_buffer_fuzzy_find,
      { desc = "[S]earch current [B]uffer lines" }
    )
    vim.keymap.set("n", "<leader>sB", function()
      require("telescope.builtin").live_grep {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Buffers",
      }
    end, { desc = "[S]earch in open buffers" })
    vim.keymap.set("n", "<leader>sg", require("telescope").extensions.egrepify.egrepify, { desc = "[S]earch by Grep" })
    vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch [W]ord" })
    vim.keymap.set("v", "<leader>sw", function()
      require("telescope.builtin").grep_string({ search = utils.get_visual_selection() })
    end, { desc = "[S]earch [W]ord" })
    vim.keymap.set("n", "<leader>si", function()
      require("telescope.builtin").symbols({ sources = { "emoji", "kaomoji", "gitmoji" } })
    end, { desc = "[S]earch emoji [I]cons" })
    vim.keymap.set("n", "<leader>sd", require("telescope").extensions.aerial.aerial,
      { desc = "[S]earch [D]ocument Symbols" })
    vim.keymap.set("n", "<leader>sx", function()
      require("telescope.builtin").diagnostics({ bufnr = 0 })
    end, { desc = "[S]earch diagnostics in current buffer" })
    vim.keymap.set("n", "<leader>sX", function()
      require("telescope.builtin").diagnostics({ workspace = true })
    end, { desc = "[S]earch diagnostics in workspace" })
    vim.keymap.set("n", "<leader>sq", require("telescope.builtin").quickfix, { desc = "[S]earch [Q]uickfix List" })
    vim.keymap.set("n", "<leader>sQ", require("telescope.builtin").quickfixhistory,
      { desc = "[S]earch [Q]uickfix History" })
    vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sH", require("telescope.builtin").highlights, { desc = "[S]earch [H]ighlights" })
    vim.keymap.set("n", "<leader>sp", require("telescope.builtin").pickers, { desc = "[S]earch [P]ickers" })
    vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })

    -- Git
    local git_attach_mappings = function(_, map)
      local open_commit = function(prompt_bufnr)
        actions.close(prompt_bufnr)

        local selection = action_state.get_selected_entry()
        local commit_hash = selection.value
        vim.api.nvim_command(":Gedit " .. commit_hash)
      end

      local copy_to_clipboard = function(_)
        local selection = action_state.get_selected_entry()
        local commit_hash = selection.value
        vim.notify(
          "Copied commit hash " .. commit_hash .. " to clipboard",
          vim.log.levels.INFO
        )

        vim.fn.setreg("+", commit_hash)
        vim.fn.setreg("*", commit_hash)
      end

      local open_pr_in_browser = function(_)
        local selection = action_state.get_selected_entry()
        local msg = selection.msg
        local pr_number = tonumber(
          msg:match("%(#(%d+)%)%s*$")
        )
        if pr_number ~= nil then
          vim.cmd(":Browse (#" .. pr_number .. ")")
        end
      end

      map("i", "<CR>", open_commit)
      map("i", "<C-y>", copy_to_clipboard)
      map("i", "<C-b>", open_pr_in_browser)

      -- needs to return true if you want to map default_mappings and
      -- false if not
      return true
    end

    vim.keymap.set("n", "<leader>gs", function()
      require("telescope.builtin").git_status({ layout_strategy = "center" })
    end, { desc = "[G]it [S]tatus" })
    vim.keymap.set("n", "<leader>gS", function()
      require("telescope.builtin").git_stash({ layout_strategy = "center" })
    end, { desc = "[G]it [S]tash" })
    vim.keymap.set("n", "<leader>gB", function()
      require("telescope.builtin").git_branches()
    end, { desc = "[G]it [B]ranches" })
    vim.keymap.set("n", "<leader>gl", function()
      require("telescope.builtin").git_commits({
        layout_strategy = "center",
        -- git_command = { "git", "log", "--oneline", "--pretty=format:%h %cr %an %s", "--", "." },
        attach_mappings = git_attach_mappings,
      })
    end, { desc = "[G]it [L]og" })
    vim.keymap.set("n", "<leader>gL", function()
      require("telescope.builtin").git_bcommits({
        layout_strategy = "center",
        -- git_command = { "git", "log", "--oneline", "--pretty=format:%h (%cr) (%an) %s" },
        attach_mappings = git_attach_mappings,
      })
    end, { desc = "[G]it [L]og current buffer" })
    vim.keymap.set("x", "<leader>gl", function()
      vim.cmd([[ execute "normal! \<ESC>" ]])
      local start_pos = vim.api.nvim_buf_get_mark(0, "<")[1]
      local end_pos = vim.api.nvim_buf_get_mark(0, ">")[1]

      print(start_pos, end_pos)
      require("telescope.builtin").git_bcommits_range({
        layout_strategy = "center",
        from = start_pos,
        to = end_pos,
        -- git_command = { "git", "log", "--oneline", "--pretty=format:%h (%cr) (%an) %s" },
        attach_mappings = git_attach_mappings,
      })
    end, { desc = "[G]it [L]og current line", silent = true })
  end
}
