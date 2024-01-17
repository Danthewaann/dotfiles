return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
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
    }
  },
  config = function()
    local actions = require("telescope.actions")
    local dropdown_layout_config = {
      height = 0.6,
      width = 0.6
    }
    local grep_args = function(_)
      return { "--hidden" }
    end

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
        file_ignore_patterns = {
          "^vendor/",
          "^.git/",
          "^node_modules/",
          "^.venv/",
          "^.mypy_cache/",
          "^.cache/",
          "__pycache__",
          "^.coverage/",
        },
        layout_strategy = "horizontal",
        layout_config = {
          vertical = { height = 0.8, width = 0.7, preview_height = 0.4 },
          horizontal = { height = 0.8, width = 0.7, preview_width = 0.55 },
        },
        mappings = {
          ["i"] = {
            ["<C-r>"] = actions.to_fuzzy_refine,
          }
        }
      },
      pickers = {
        marks = { theme = "dropdown", previewer = false, layout_config = { width = 0.5 } },
        lsp_definitions = { theme = "ivy", show_line = false },
        lsp_references = { theme = "ivy", include_declaration = false, show_line = false },
        lsp_implementations = { theme = "ivy", show_line = false },
        lsp_type_definitions = { theme = "ivy" },
        lsp_incoming_calls = { theme = "ivy", path_display = { "smart" }, fname_width = 0.5, symbol_width = 0.5 },
        lsp_outgoing_calls = { theme = "ivy", path_display = { "smart" }, fname_width = 0.5, symbol_width = 0.5 },
        lsp_workspace_symbols = { theme = "ivy", path_display = { "smart" }, fname_width = 0.4, symbol_width = 0.5 },
        lsp_dynamic_workspace_symbols = {
          theme = "ivy",
          path_display = { "smart" },
          fname_width = 0.4,
          symbol_width = 0.5
        },
        lsp_document_symbols = { theme = "ivy", previewer = false, symbol_width = 0.9 },
        current_buffer_fuzzy_find = { theme = "dropdown", previewer = false, layout_config = { width = 0.5 } },
        buffers = { theme = "dropdown", previewer = false, sort_mru = true, ignore_current_buffer = true, layout_config = { width = 0.5 } },
        oldfiles = { theme = "dropdown", previewer = false, layout_config = dropdown_layout_config },
        find_files = {
          theme = "dropdown",
          previewer = false,
          hidden = true,
          layout_config = dropdown_layout_config,
        },
        help_tags = { theme = "ivy" },
        git_commits = { theme = "ivy" },
        git_status = { theme = "ivy" },
        search_history = { theme = "dropdown" },
        command_history = { theme = "dropdown" },
        -- TODO: this doesn't work as when you select a picker
        -- the telescope picker layout doesn't update correctly
        -- pickers = {
        --   theme = "dropdown",
        --   previewer = false,
        -- },
        man_pages = { theme = "ivy", previewer = false },
        diagnostics = { theme = "ivy", wrap_results = true },
        grep_string = { theme = "ivy", use_regex = true, additional_args = grep_args },
        live_grep = { theme = "ivy", use_regex = true, additional_args = grep_args },
      },
      extensions = {
        import = require("telescope.themes").get_dropdown()
      }
    })

    local utils = require("custom.utils")

    -- Enable telescope extensions, if installed
    pcall(require("telescope").load_extension, "fzf")

    -- See `:help telescope.builtin`
    vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
    vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
    vim.keymap.set("n", "<leader>/", require("telescope.builtin").current_buffer_fuzzy_find,
      { desc = "[/] Fuzzily search in current buffer" }
    )
    vim.keymap.set("n", "<leader>s/", function()
      require("telescope.builtin").live_grep {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      }
    end, { desc = "[S]earch [/] in Open Files" })
    vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, { desc = "Search Files" })
    vim.keymap.set("n", "<leader>sb", require("telescope.builtin").builtin, { desc = "[S]earch [B]uiltin Telescope" })
    vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sm", require("telescope.builtin").man_pages, { desc = "[S]earch [M]an Pages" })
    vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>sp", require("telescope.builtin").pickers, { desc = "[S]earch [P]ickers" })
    vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_status, { desc = "[G]it [F]iles" })
    vim.keymap.set("n", "<leader>gls", require("telescope.builtin").git_commits, { desc = "[G]it [L]og [S]earch" })

    -- Search for pattern in current project files
    vim.keymap.set("n", "<leader>ps", function()
      vim.ui.input({ prompt = "Project Search:" }, function(search)
        if search then
          require("telescope.builtin").grep_string({ search = search })
        end
      end)
    end, { desc = "[P]roject [S]earch" })

    -- Search for the current word in project files
    vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "[F]ind [W]ord" })
    vim.keymap.set("v", "<leader>fw", function()
      require("telescope.builtin").grep_string({ search = utils.get_visual_selection() })
    end, { desc = "[F]ind [W]ord" })
  end
}
