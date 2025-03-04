return {
  "nvim-telescope/telescope.nvim",
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
    local ivy_layout_config = {
      height = { padding = 0 },
      width = { padding = 0 }
    }
    local grep_args = function(_)
      return { "--hidden" }
    end

    -- Action to open the first entry in the quickfix list after opening it
    local open_and_select_first_qf_entry = require("telescope.actions.mt").transform_mod({
      mod = function()
        vim.cmd(":botright copen | cc 1")
      end
    }).mod

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
        mappings = {
          ["i"] = {
            ["<C-space>"] = "to_fuzzy_refine",
            ["<C-q>"] = require("telescope.actions").send_to_qflist + open_and_select_first_qf_entry,
            ["<C-o>"] = require("telescope.actions.layout").toggle_preview,
          }
        }
      },
      pickers = {
        builtin = {
          theme = "ivy",
          path_display = { "filename_first" },
          show_line = false,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        pickers = {
          theme = "ivy",
          path_display = { "filename_first" },
          show_line = false,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        lsp_definitions = {
          theme = "ivy",
          path_display = { "filename_first" },
          show_line = false,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        lsp_references = {
          theme = "ivy",
          path_display = { "filename_first" },
          include_declaration = false,
          show_line = false,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        lsp_implementations = {
          theme = "ivy",
          path_display = { "filename_first" },
          show_line = true,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        lsp_type_definitions = {
          theme = "ivy",
          path_display = { "filename_first" },
          results_title = false,
          layout_config = ivy_layout_config,
        },
        lsp_incoming_calls = {
          theme = "ivy",
          previewer = true,
          path_display = { "filename_first" },
          fname_width = 0.6,
          symbol_width = 0.4,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        lsp_outgoing_calls = {
          theme = "ivy",
          previewer = true,
          path_display = { "filename_first" },
          fname_width = 0.6,
          symbol_width = 0.4,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        lsp_workspace_symbols = {
          theme = "ivy",
          previewer = true,
          path_display = { "filename_first" },
          fname_width = 0.6,
          symbol_width = 0.3,
          symbol_type_width = 0.1,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        lsp_dynamic_workspace_symbols = {
          theme = "ivy",
          previewer = true,
          path_display = { "filename_first" },
          fname_width = 0.6,
          symbol_width = 0.3,
          symbol_type_width = 0.1,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        lsp_document_symbols = {
          theme = "ivy",
          previewer = true,
          symbol_width = 0.9,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        current_buffer_fuzzy_find = {
          theme = "ivy",
          previewer = false,
          layout_config = ivy_layout_config,
        },
        buffers = {
          theme = "ivy",
          previewer = true,
          sort_mru = true,
          ignore_current_buffer = true,
          results_title = false,
          path_display = { "filename_first" },
          layout_config = ivy_layout_config,
        },
        oldfiles = {
          theme = "ivy",
          previewer = true,
          results_title = false,
          path_display = { "filename_first" },
          layout_config = ivy_layout_config,
        },
        find_files = {
          theme = "ivy",
          previewer = true,
          no_ignore = true,
          hidden = true,
          results_title = false,
          path_display = { "filename_first" },
          layout_config = ivy_layout_config,
        },
        git_files = {
          theme = "ivy",
          previewer = true,
          results_title = false,
          path_display = { "filename_first" },
          layout_config = ivy_layout_config,
        },
        git_status = {
          theme = "ivy",
          previewer = true,
          results_title = false,
          path_display = { "filename_first" },
          layout_config = ivy_layout_config,
        },
        help_tags = { theme = "ivy", results_title = false, layout_config = ivy_layout_config, },
        git_commits = { theme = "ivy", results_title = false, layout_config = ivy_layout_config, },
        search_history = { theme = "ivy", layout_config = ivy_layout_config },
        command_history = { theme = "ivy", layout_config = ivy_layout_config },
        -- TODO: this doesn't work as when you select a picker
        -- the telescope picker layout doesn't update correctly
        -- pickers = {
        --   theme = "dropdown",
        --   previewer = false,
        -- },
        man_pages = { theme = "ivy", previewer = false, results_title = false, layout_config = ivy_layout_config, },
        diagnostics = {
          theme = "ivy",
          path_display = { "filename_first" },
          disable_coordinates = true,
          sort_by = "severity",
          previewer = false,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        grep_string = {
          theme = "ivy",
          previewer = true,
          path_display = { "filename_first" },
          use_regex = true,
          additional_args = grep_args,
          results_title = false,
          layout_config = ivy_layout_config,
        },
        live_grep = {
          theme = "ivy",
          previewer = true,
          path_display = { "filename_first" },
          use_regex = true,
          additional_args = grep_args,
          results_title = false,
          layout_config = ivy_layout_config,
        },
      },
      extensions = {
        fzf = {}
      }
    })

    local utils = require("custom.utils")

    -- Enable telescope extensions, if installed
    pcall(require("telescope").load_extension, "fzf")

    -- See `:help telescope.builtin`
    vim.keymap.set("n", "<leader>.", function()
      require("telescope.builtin").oldfiles({ only_cwd = true })
    end, { desc = "[.] Find recently opened files" })
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
    vim.keymap.set("n", "<leader>s.", function()
      require("telescope.builtin").find_files {
        cwd = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h"),
        prompt_title = "Find Files (Current Directory)"
      }
    end, { desc = "[S]earch [.] files in current directory" })
    vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files, { desc = "Search Files" })
    vim.keymap.set("n", "<C-f>", require("telescope.builtin").git_files, { desc = "Search Git Files" })
    vim.keymap.set("n", "<C-e>", require("telescope.builtin").git_status, { desc = "Search Git Status" })
    vim.keymap.set("n", "<leader>sb", require("telescope.builtin").builtin, { desc = "[S]earch [B]uiltin Telescope" })
    vim.keymap.set("n", "<leader>sc", require("telescope.builtin").command_history,
      { desc = "[S]earch [C]ommand History" })
    vim.keymap.set("n", "<leader>si", require("telescope.builtin").search_history, { desc = "[S]earch H[i]story" })
    vim.keymap.set("n", "<leader>sx", require("telescope.builtin").diagnostics, { desc = "[S]earch Diagnostics" })
    vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sm", require("telescope.builtin").man_pages, { desc = "[S]earch [M]an Pages" })
    vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sp", require("telescope.builtin").pickers, { desc = "[S]earch [P]ickers" })
    vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch [W]ord" })
    vim.keymap.set("v", "<leader>sw", function()
      require("telescope.builtin").grep_string({ search = utils.get_visual_selection() })
    end, { desc = "[S]earch [W]ord" })
  end
}
