return {
  "alvarosevilla95/luatab.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("luatab").setup({
      title = function(bufnr)
        local file = vim.fn.bufname(bufnr)
        local buftype = vim.fn.getbufvar(bufnr, "&buftype")
        local filetype = vim.fn.getbufvar(bufnr, "&filetype")

        if buftype == "help" then
          return "help:" .. vim.fn.fnamemodify(file, ":t:r")
        elseif buftype == "quickfix" then
          return "quickfix"
        elseif filetype == "TelescopePrompt" then
          return "Telescope"
        elseif filetype == "git" then
          return "Git"
        elseif filetype == "fugitive" then
          return "Fugitive"
        elseif filetype == "NvimTree" then
          return "NvimTree"
        elseif filetype == "oil" then
          return "Oil"
        elseif file:sub(file:len() - 2, file:len()) == "FZF" then
          return "FZF"
        elseif buftype == "terminal" then
          local _, mtch = string.match(file, "term:(.*):(%a+)")
          return mtch ~= nil and mtch or vim.fn.fnamemodify(vim.env.SHELL, ":t")
        elseif file == "" then
          return "[No Name]"
        else
          return vim.fn.fnamemodify(file, ":p:~:.")
        end
      end,
      devicon = function(bufnr, isSelected)
        local icon, devhl
        local file = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t")
        local buftype = vim.fn.getbufvar(bufnr, "&buftype")
        local filetype = vim.fn.getbufvar(bufnr, "&filetype")
        local devicons = require "nvim-web-devicons"
        if filetype == "TelescopePrompt" then
          icon, devhl = devicons.get_icon("telescope")
        elseif filetype == "NeogitStatus" then
          icon, devhl = devicons.get_icon("git")
        elseif filetype == "NeogitPopup" then
          icon, devhl = devicons.get_icon("git")
        elseif filetype == "NeogitLogView" then
          icon, devhl = devicons.get_icon("git")
        elseif filetype == "NeogitCommitView" then
          icon, devhl = devicons.get_icon("git")
        elseif filetype == "vimwiki" then
          icon, devhl = devicons.get_icon("markdown")
        elseif filetype == "dbui" then
          icon, devhl = devicons.get_icon("db")
        elseif filetype == "mysql" then
          icon, devhl = devicons.get_icon("sql")
        elseif filetype == "pgsql" then
          icon, devhl = devicons.get_icon("sql")
        elseif filetype == "sql" then
          icon, devhl = devicons.get_icon("sql")
        elseif buftype == "terminal" then
          icon, devhl = devicons.get_icon("zsh")
        else
          icon, devhl = devicons.get_icon(file, vim.fn.expand("#" .. bufnr .. ":e"))
        end
        if icon then
          local h = require "luatab.highlight"
          local fg = h.extract_highlight_colors(devhl, "fg")
          local bg = h.extract_highlight_colors("TabLineSel", "bg")
          local hl = h.create_component_highlight_group({ bg = bg, fg = fg }, devhl)
          local selectedHlStart = (isSelected and hl) and "%#" .. hl .. "#" or ""
          local selectedHlEnd = isSelected and "%#TabLineSel#" or ""
          return selectedHlStart .. icon .. selectedHlEnd .. " "
        end
        return ""
      end,
      tabline = function()
        local line = ""
        for i = 1, vim.fn.tabpagenr("$"), 1 do
          line = line .. require("luatab").helpers.cell(i)
        end
        line = line .. "%#TabLineFill#%="
        return line
      end,
      windowCount = function() return "" end,
    })
  end
}
