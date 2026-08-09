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
      "html",
    }

    require("nvim-treesitter").install(parsers)

    ---@param buf integer
    ---@param language string
    local function treesitter_try_attach(buf, language)
      if not vim.treesitter.language.add(language) then return end
      vim.treesitter.start(buf, language)

      -- Enable treesitter based folds
      -- For more info on folds see `:help folds`
      -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      -- vim.wo.foldmethod = 'expr'

      -- Check if treesitter indentation is available for this language, and if so enable it
      -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
      local has_indent_query = vim.treesitter.query.get(language, "indents") ~= nil

      -- Enable treesitter based indentation
      if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf, filetype = args.buf, args.match
        local language = vim.treesitter.language.get_lang(filetype)
        if not language then return end

        local installed_parsers = require("nvim-treesitter").get_installed("parsers")
        if vim.tbl_contains(installed_parsers, language) then
          treesitter_try_attach(buf, language)
        else
          -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
          treesitter_try_attach(buf, language)
        end
      end,
    })
  end
}
