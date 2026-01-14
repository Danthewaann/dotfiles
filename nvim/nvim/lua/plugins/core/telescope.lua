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
        layout_config = {
          center = {
            anchor = "S",
            anchor_padding = 0,
            height = 0.60,
            width = { padding = 0 },
            preview_cutoff = 1,
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
            ["<C-e>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
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
        },
        man_pages = { previewer = false },
        diagnostics = {
          sort_by = "severity",
          previewer = false
        },
        grep_string = {
          additional_args = {}
        },
        live_grep = {
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
        }
      }
    })

    local utils = require("custom.utils")

    -- Enable telescope extensions, if installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "aerial")
    pcall(require("telescope").load_extension, "egrepify")

    -- See `:help telescope.builtin`
    vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "Search Open Files" })
    vim.keymap.set("n", "<leader>/", require("telescope.builtin").current_buffer_fuzzy_find,
      { desc = "[S]earch Fuzzily in current buffer [/]" }
    )
    vim.keymap.set("n", "<C-f>", require("telescope.builtin").find_files, { desc = "Search Files" })
    vim.keymap.set("n", "<C-p>", require("telescope.builtin").git_files, { desc = "Search Git Tracked Files" })
    vim.keymap.set("n", "<C-g>", require("telescope.builtin").git_status, { desc = "Search Changed Git Files" })
    vim.keymap.set("n", "<leader>sb", require("telescope.builtin").builtin, { desc = "[S]earch [B]uiltin Telescope" })
    vim.keymap.set("n", "<leader>sc", require("telescope.builtin").command_history,
      { desc = "[S]earch [C]ommand History" })
    vim.keymap.set("n", "<leader>sd", require("telescope").extensions.aerial.aerial,
      { desc = "[S]earch [D]ocument Symbols" })
    vim.keymap.set("n", "<leader>si", require("telescope.builtin").search_history, { desc = "[S]earch H[i]story" })
    vim.keymap.set("n", "<leader>sx", require("telescope.builtin").diagnostics, { desc = "[S]earch Diagnostics" })
    vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>so", function()
      require("telescope.builtin").oldfiles({ only_cwd = true })
    end, { desc = "[S]earch Recently [O]pened Files" })
    vim.keymap.set("n", "<leader>ss", function()
      require("telescope").extensions.egrepify.egrepify({ layout_strategy = "center" })
    end, { desc = "[S]earch by Grep" })
    vim.keymap.set("n", "<leader>sp", require("telescope.builtin").pickers, { desc = "[S]earch [P]ickers" })
    vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>sw", function()
      require("telescope.builtin").grep_string({ layout_strategy = "center" })
    end, { desc = "[S]earch [W]ord" })
    vim.keymap.set("v", "<leader>sw", function()
      require("telescope.builtin").grep_string({ search = utils.get_visual_selection(), layout_strategy = "center" })
    end, { desc = "[S]earch [W]ord" })
  end
}
