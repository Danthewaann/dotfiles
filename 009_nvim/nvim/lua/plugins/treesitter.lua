return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  config = function()
    local utils = require("custom.utils")

    -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
    vim.defer_fn(function()
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
          "c",
          "cpp",
          "go",
          "gomod",
          "gosum",
          "lua",
          "python",
          "rust",
          "tsx",
          "javascript",
          "typescript",
          "vimdoc",
          "vim",
          "bash",
          "regex",
          "query",
          "ruby",
          "http",
          "json",
          "markdown",
          "markdown_inline",
          "gitcommit",
          "make",
          "dockerfile",
          "yaml",
          "sql",
          "toml",
          "terraform",
        },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = false,

        highlight = {
          enable = true,
          disable = function(_, buf)
            -- Disable highlighting for large files
            local max_filesize = 200 * 1024 -- 200 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-a>",
            node_decremental = "<c-x>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ib"] = "@block.inner",
              ["ab"] = "@block.outer",
              ["il"] = "@assignment.lhs",
              ["ir"] = "@assignment.rhs",
              ["im"] = "@assignment.outer",
              ["in"] = "@conditional.inner",
              ["an"] = "@conditional.outer",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })

      if utils.apply_folds(vim.api.nvim_get_current_buf()) then
        -- Refresh the buffer after applying folds to get treesitter to
        -- refresh highlights
        vim.cmd(":e")
        vim.defer_fn(function()
          vim.cmd("silent! loadview")
        end, 0)
      end
    end, 0)
  end
}
