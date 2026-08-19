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

    local filetype_inactive_config = {
      "filetype",
      colored = false,
      icon_only = false,
      icon = { align = "right" },
    }

    local fileformat_config = {
      "fileformat",
      icons_enabled = true,
      symbols = {
        unix = "LF",
        dos = "CRLF",
        mac = "CR",
      },
    }

    local git_shortstat = function()
      local obj = vim.system({ "git", "--no-pager", "diff", "HEAD", "--shortstat" }):wait()
      if obj.code ~= 0 then
        return ""
      end
      return obj.stdout:match("^%s*(.-)%s*$")
    end

    local lint_progress = function()
      local linters = require("lint").get_running()
      if #linters == 0 then
        return "󰦕"
      end
      return "󱉶 " .. table.concat(linters, ", ")
    end

    local list_harpoon = function()
      local bufname = vim.fn.bufname(vim.api.nvim_get_current_buf())
      local harpoon = require("harpoon")
      local list = harpoon:list()
      local items = {}
      for i, x in ipairs(list.items) do
        if x.value ~= bufname then
          table.insert(items, "%#lualine_a_normal#" .. i .. "%*:" .. vim.fn.fnamemodify(x.value, ":t"))
        end
      end
      return table.concat(items, " ")
    end

    local function diff_source()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed
        }
      end
    end

    local dashboard_extension = {
      sections = {
        lualine_a = {
          function()
            local version = vim.version()
            return string.format("%d.%d.%d", version.major, version.minor, version.patch)
          end,
        },
        lualine_b = { git_shortstat },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { list_harpoon },
      },

      filetypes = { "dashboard" }
    }

    local fugitive_extension = require("lualine.extensions.fugitive")
    fugitive_extension.sections.lualine_x = { git_shortstat }

    require("lualine").setup({
      options = {
        theme = custom_theme,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = { "dbui", "git", "dashboard" },
        globalstatus = false,
        always_show_tabline = false,
        disabled_filetypes = { statusline = { "TelescopePrompt" } },
      },
      extensions = { "man", "quickfix", fugitive_extension, "aerial", "symbols-outline", dashboard_extension, "oil" },
      sections = {
        lualine_a = {},
        lualine_b = { filename_config, { "diff", source = diff_source }, "diagnostics", lint_progress },
        lualine_c = {
          filetype_config,
          "filesize",
          fileformat_config,
          "progess",
          "location",
          "searchcount",
          "selectioncount",
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { list_harpoon },
      },
      inactive_sections = {
        lualine_c = { filename_config, filetype_inactive_config, "filesize", fileformat_config, "location" },
        lualine_x = {},
      },
    })
  end,
}
