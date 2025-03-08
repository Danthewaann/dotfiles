return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  -- See `:help lualine.txt`
  config = function()
    -- Custom onedark theme
    -- From https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/themes/onedark.lua
    local colors = {
      blue   = "#61afef",
      green  = "#98c379",
      purple = "#c678dd",
      cyan   = "#56b6c2",
      red1   = "#e06c75",
      red2   = "#be5046",
      yellow = "#e5c07b",
      fg     = "#abb2bf",
      bg     = "#1a1d21",
      bg2    = "#272731",
      gray1  = "#828997",
      gray2  = "#2c323c",
      gray3  = "#3e4452",
    }

    local custom_theme = {
      normal = {
        a = { fg = colors.green, bg = colors.bg2 },
        b = { fg = colors.fg, bg = colors.bg2 },
        c = { fg = colors.fg, bg = colors.bg2 },
        z = { fg = colors.fg, bg = colors.bg2 },
      },
      command = {
        a = { fg = colors.yellow, bg = colors.bg2 },
        z = { fg = colors.fg, bg = colors.bg2 },
      },
      insert = {
        a = { fg = colors.blue, bg = colors.bg2 },
        z = { fg = colors.fg, bg = colors.bg2 },
      },
      visual = {
        a = { fg = colors.purple, bg = colors.bg2 },
        z = { fg = colors.fg, bg = colors.bg2 },
      },
      terminal = {
        a = { fg = colors.cyan, bg = colors.bg2 },
        z = { fg = colors.fg, bg = colors.bg2 },
      },
      replace = {
        a = { fg = colors.red1, bg = colors.bg2 },
        z = { fg = colors.fg, bg = colors.bg2 },
      },
      inactive = {
        a = { fg = colors.gray1, bg = colors.bg2 },
        b = { fg = colors.gray1, bg = colors.bg2 },
        c = { fg = colors.gray1, bg = colors.bg2 },
      },
    }

    local filename_config = {
      "filename",
      file_status = true,    -- Displays file status (readonly status, modified status)
      newfile_status = true, -- Display new file status (new file means no write after created)
      path = 1,              -- 0: Just the filename
      -- 1: Relative path
      -- 2: Absolute path
      -- 3: Absolute path, with tilde as the home directory
      -- 4: Filename and parent dir, with tilde as the home directory
      shorting_target = 40, -- Shortens path to leave 40 spaces in the window
      -- for other components. (terrible name, any suggestions?)
      symbols = {
        modified = "[+]",      -- Text to show when the file is modified.
        readonly = "[-]",      -- Text to show when the file is non-modifiable or readonly.
        unnamed = "[No Name]", -- Text to show for unnamed buffers.
        newfile = "[New]",     -- Text to show for newly created file before first write
      },
    }

    local filetype_config = {
      "filetype",
      colored = true,             -- Displays filetype icon in color if set to true
      icon_only = false,          -- Display only an icon for filetype
      icon = { align = "right" }, -- Display filetype icon on the right hand side
    }

    require("lualine").setup({
      options = {
        theme = custom_theme,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = { "dbui", "git" },
        globalstatus = false,
        always_show_tabline = false,
        disabled_filetypes = { statusline = { "TelescopePrompt", "ministarter" } },
      },
      extensions = { "man", "quickfix" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { filename_config },
        lualine_c = {},
        lualine_x = { "searchcount", filetype_config, "progress" },
        lualine_y = {},
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_c = { filename_config },
      },
    })
  end,
}
