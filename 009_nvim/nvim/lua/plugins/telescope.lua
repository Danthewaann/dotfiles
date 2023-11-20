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
    },
    "nvim-telescope/telescope-file-browser.nvim",
    "piersolenski/telescope-import.nvim"
  },
  config = function()
    local actions = require("telescope.actions")
    local default_layout_config = {
      height = 0.6,
      width = 0.6
    }

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
          "^vendor",
          "^.git",
          "^node_modules",
          "^.venv",
          "^.mypy_cache",
          "^.cache",
          "__pycache__",
          "^.coverage",
        },
        layout_strategy = "horizontal",
        layout_config = {
          vertical = { height = 0.8, width = 0.7, preview_height = 0.4 },
          horizontal = { height = 0.8, width = 0.7, preview_width = 0.55 },
        },
      },
      pickers = {
        lsp_definitions = {
          theme = "dropdown",
          previewer = true,
          show_line = false,
          fname_width = 70,
          layout_config = default_layout_config,
        },
        lsp_references = {
          theme = "ivy",
          previewer = true,
          include_declaration = false,
          show_line = false,
          layout_config = default_layout_config,
        },
        lsp_implementations = {
          theme = "dropdown",
          previewer = true,
          show_line = false,
          layout_config = default_layout_config,
        },
        lsp_type_definitions = {
          theme = "dropdown",
          previewer = true,
          layout_config = default_layout_config,
        },
        lsp_workspace_symbols = {
          theme = "dropdown",
          previewer = true,
          fname_width = 0.5,
          symbol_width = 0.4,
          layout_config = default_layout_config,
        },
        lsp_dynamic_workspace_symbols = {
          theme = "dropdown",
          previewer = true,
          fname_width = 0.5,
          symbol_width = 0.4,
          layout_config = default_layout_config,
        },
        lsp_document_symbols = {
          theme = "dropdown",
          previewer = false,
          symbol_width = 0.9,
          layout_config = default_layout_config,
        },
        oldfiles = {
          theme = "dropdown",
          previewer = false,
          layout_config = default_layout_config,
        },
        find_files = {
          theme = "dropdown",
          previewer = false,
          layout_config = default_layout_config,
        },
        help_tags = {
          theme = "ivy",
          previewer = true,
          layout_config = {
            height = 0.5,
            width = 0.5,
          },
        },
        git_commits = {
          theme = "ivy",
          previewer = true,
          layout_config = {
            height = 0.4,
            width = 0.5
          },
        },
        git_status = {
          theme = "ivy",
          previewer = true,
          layout_config = {
            height = 0.4,
            width = 0.5
          },
        },
        search_history = {
          theme = "dropdown",
        },
        command_history = {
          theme = "dropdown",
        },
        -- TODO: this doesn't work as when you select a picker
        -- the telescope picker layout doesn't update correctly
        -- pickers = {
        --   theme = "dropdown",
        --   previewer = false,
        -- },
        man_pages = {
          theme = "ivy",
          previewer = false,
          layout_config = default_layout_config,
        },
        diagnostics = {
          theme = "ivy",
          previewer = true,
          wrap_results = true,
          layout_config = default_layout_config,
        },
        grep_string = {
          theme = "ivy",
          preview = true,
          use_regex = true,
          layout_config = default_layout_config,
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
        live_grep = {
          theme = "ivy",
          previewer = true,
          use_regex = true,
          disable_coordinates = true,
          layout_config = default_layout_config,
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
      },
      extensions = {
        import = require("telescope.themes").get_dropdown(),
        file_browser = {
          theme = "dropdown",
          layout_config = default_layout_config,
          hijack_netrw = true,
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          mappings = {
            ["n"] = {
              ["e"] = false,
              ["<C-U>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-D>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
            },
            ["i"] = {
              ["<C-e>"] = false,
              ["<C-u>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
            }
          }
        },
      }
    })

    local utils = require("custom.utils")

    -- Enable telescope extensions, if installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "import")
    pcall(require("telescope").load_extension, "file_browser")

    -- See `:help telescope.builtin`
    vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
    vim.keymap.set("n", "<leader><space>", function()
      require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({
        previewer = false,
        sort_mru = true,
        ignore_current_buffer = true,
      }))
    end, { desc = "[ ] Find existing buffers" })
    vim.keymap.set("n", "<leader>/", function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        previewer = false,
      }))
    end, { desc = "[/] Fuzzily search in current buffer" })
    vim.keymap.set("n", "<C-p>", function()
      require("telescope.builtin").find_files({ hidden = true, no_ignore = false })
    end, { desc = "Search Files" })
    vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sm", require("telescope.builtin").man_pages, { desc = "[S]earch [M]an Pages" })
    vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", function()
      require("telescope.builtin").diagnostics({ line_width = 0.9, bufnr = 0 })
    end, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>sp", require("telescope.builtin").pickers, { desc = "[S]earch [P]ickers" })
    vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_status, { desc = "[G]it [F]iles" })
    vim.keymap.set("n", "<leader>gtl", require("telescope.builtin").git_commits, { desc = "[G]it [T]elescope [L]ogs" })
    vim.keymap.set("n", "<leader>ii", require("telescope").extensions.import.import, { desc = "[I]nsert [I]mport" })
    vim.keymap.set("n", "<leader>fb", require("telescope").extensions.file_browser.file_browser)
    vim.keymap.set("n", "<leader>ff", function()
      require("telescope").extensions.file_browser.file_browser({
        path = "%:p:h",
      })
    end)

    -- Search for pattern in current project files
    vim.keymap.set("n", "<leader>ps", function()
      vim.ui.input({ prompt = "Project Search:" }, function(search)
        if search then
          require("telescope.builtin").grep_string({ search = search })
        end
      end)
    end, { desc = "[P]roject [S]earch" })

    -- Search for the current word in project files
    vim.keymap.set("n", "<leader>F", require("telescope.builtin").grep_string, { desc = "[F]ind word" })
    vim.keymap.set("v", "<leader>F", function()
      require("telescope.builtin").grep_string({ search = utils.get_visual_selection() })
    end, { desc = "[F]ind word" })
  end
}
