return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
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
      "sh",
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
  end
}
