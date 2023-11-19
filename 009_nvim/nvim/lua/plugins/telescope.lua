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
  config = function ()
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-q>"] = require("trouble.providers.telescope").open_with_trouble,
          },
          n = {
            ["<C-q>"] = require("trouble.providers.telescope").open_with_trouble,
          },
        },
        -- Cache the last 10 pickers so I can resume them later
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
          "vendor",
        },
        layout_strategy = "vertical",
        layout_config = {
          vertical = { height = 0.8, width = 0.7, preview_height = 0.4 },
          horizontal = { height = 0.8, width = 0.7, preview_width = 0.55 },
        },
      },
      pickers = {
        live_grep = {
          additional_args = function(_)
            return { "--hidden" }
          end,
        },
      },
      extensions = {
        file_browser = {
          layout_strategy = "horizontal",
          hijack_netrw = true,
          hidden = true,
          grouped = true,
          previewer = true,
          initial_mode = "normal",
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
    vim.keymap.set("n", "<C-f>", function()
      require("telescope.builtin").git_files({ layout_strategy = "horizontal" })
    end, { desc = "Search Git Files" })
    vim.keymap.set("n", "<C-p>", function()
      require("telescope.builtin").find_files({ layout_strategy = "horizontal", hidden = true })
    end, { desc = "Search Files" })
    vim.keymap.set("n", "<leader>sh", function()
      require("telescope.builtin").help_tags({ layout_strategy = "horizontal" })
    end, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sm", function()
      require("telescope.builtin").man_pages({ layout_strategy = "horizontal" })
    end, { desc = "[S]earch [M]an Pages" })
    vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>sp", require("telescope.builtin").pickers, { desc = "[S]earch [P]ickers" })
    vim.keymap.set("n", "<leader>gf", function()
      require("telescope.builtin").git_status({ layout_strategy = "horizontal" })
    end, { desc = "[G]it [F]iles" })
    vim.keymap.set("n", "<leader>gtl", require("telescope.builtin").git_commits, { desc = "[G]it [T]elescope [L]ogs" })
    vim.keymap.set("n", "<leader>ii", require("telescope").extensions.import.import, { desc = "[I]nsert [I]mport" })
    vim.keymap.set("n", "<leader>fb", function()
      require("telescope").extensions.file_browser.file_browser()
    end)
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
