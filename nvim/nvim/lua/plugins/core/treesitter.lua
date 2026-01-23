return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- The commit after this one crashes my neovim to crash when I open
  -- lua and vim files
  -- See: https://github.com/nvim-treesitter/nvim-treesitter/issues/8459
  commit = "737088f",
  build = ":TSUpdate",
  config = function()
    local parsers = {
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
      "diff",
      "gitcommit",
      "make",
      "yaml",
      "sql",
      "toml",
      "terraform",
      "objc",
      "swift",
      "just",
      "tmux",
    }

    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function()
        -- Syntax highlighting
        vim.treesitter.start()
        -- Folds
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        -- Disable the @spell and @nospell capture groups
        vim.api.nvim_set_hl(0, "@spell", { link = "NONE" })
        vim.api.nvim_set_hl(0, "@nospell", { link = "NONE" })
      end,
    })

    -- Enable bash syntax highlighting for shell files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sh" },
      callback = function(args)
        -- Syntax highlighting
        vim.treesitter.start(args.buf, "bash")
        -- Folds
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        -- Disable the @spell and @nospell capture groups
        vim.api.nvim_set_hl(0, "@spell", { link = "NONE" })
        vim.api.nvim_set_hl(0, "@nospell", { link = "NONE" })
      end,
    })
  end
}
