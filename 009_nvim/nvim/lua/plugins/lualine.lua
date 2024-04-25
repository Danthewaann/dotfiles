return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  -- See `:help lualine.txt`
  config = function()
    local utils = require("custom.utils")
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
      },
      command = { a = { fg = colors.yellow, bg = colors.bg2 } },
      insert = { a = { fg = colors.blue, bg = colors.bg2 } },
      visual = { a = { fg = colors.purple, bg = colors.bg2 } },
      terminal = { a = { fg = colors.cyan, bg = colors.bg2 } },
      replace = { a = { fg = colors.red1, bg = colors.bg2 } },
      inactive = {
        a = { fg = colors.gray1, bg = colors.bg2 },
        b = { fg = colors.gray1, bg = colors.bg2 },
        c = { fg = colors.gray1, bg = colors.bg2 },
      },
    }

    local function winbar_formatter(result)
      -- Just output the terminal command if this is a terminal job
      if string.match(result, "term:.*:.*") then
        local t = {}
        local i = 1
        for str in string.gmatch(result, "([^:]*)") do
          if i > 3 then
            t[#t + 1] = str
          end
          i = i + 1
        end
        return string.gsub(string.sub(table.concat(t, ":"), 2, -2), ":::", "::")
      elseif string.match(result, "t//.*:.*") then
        local t = {}
        local i = 1
        for str in string.gmatch(result, "([^:]*)") do
          if i > 5 then
            t[#t + 1] = str
          end
          i = i + 1
        end
        -- Remove the term path and port to only include the make command in the tabline
        return string.gsub(string.sub(table.concat(t, ":", 3), 1, -2), ":::", "::")
      end
      return result
    end

    local tabs_config = {
      "tabs",
      tab_max_length = 40,        -- Maximum width of each tab. The content will be shorten dynamically (example: apple/orange -> a/orange)
      max_length = vim.o.columns, -- Maximum width of tabs component.
      -- Note:
      -- It can also be a function that returns
      -- the value of `max_length` dynamically.
      mode = 2, -- 0: Shows tab_nr
      -- 1: Shows tab_name
      -- 2: Shows tab_nr + tab_name

      path = 0, -- 0: just shows the filename
      -- 1: shows the relative path and shorten $HOME to ~
      -- 2: shows the full path
      -- 3: shows the full path and shorten $HOME to ~
      tabs_color = {
        active = "lualine_a_normal",
        inactive = "lualine_c_inactive",
      },

      -- Automatically updates active tab color to match color of other components (will be overidden if buffers_color is set)
      use_mode_colors = false,
      component_separators = { left = "", right = "" },

      show_modified_status = true, -- Shows a symbol next to the tab name if the file has been modified.
      symbols = {
        modified = "",             -- Text to show when the file is modified.
      },

      -- Only show the tabline if there is more than one tab
      cond = function()
        if vim.fn.tabpagenr("$") > 1 then
          vim.cmd("set showtabline=2")
          return true
        end
        vim.cmd("set showtabline=1")
        return false
      end,

      fmt = function(name, context)
        -- Show + if buffer is modified in tab
        local buflist = vim.fn.tabpagebuflist(context.tabnr)
        local winnr = vim.fn.tabpagewinnr(context.tabnr)
        local bufnr = buflist[winnr]
        local mod = vim.fn.getbufvar(bufnr, "&mod")

        return name .. (mod == 1 and " +" or "")
      end
    }

    local winbar_filename_config = {
      "filename",
      file_status = true,    -- Displays file status (readonly status, modified status)
      newfile_status = true, -- Display new file status (new file means no write after created)
      path = 1,              -- 0: Just the filename
      -- 1: Relative path
      -- 2: Absolute path
      -- 3: Absolute path, with tilde as the home directory
      -- 4: Filename and parent dir, with tilde as the home directory
      fmt = winbar_formatter,
      shorting_target = 40, -- Shortens path to leave 40 spaces in the window
      -- for other components. (terrible name, any suggestions?)
      symbols = {
        modified = "[+]",      -- Text to show when the file is modified.
        readonly = "[-]",      -- Text to show when the file is non-modifiable or readonly.
        unnamed = "[No Name]", -- Text to show for unnamed buffers.
        newfile = "[New]",     -- Text to show for newly created file before first write
      },
    }

    local winbar_filetype_config = {
      "filetype",
      colored = true,             -- Displays filetype icon in color if set to true
      icon_only = false,          -- Display only an icon for filetype
      icon = { align = "right" }, -- Display filetype icon on the right hand side
    }

    local git_extension = {
      sections = {
        lualine_a = { function()
          return "Git Status"
        end }
      },
      inactive_sections = {
        lualine_c = { function()
          return "Git Status"
        end }
      },
      filetypes = { "fugitive" }
    }

    local no_winbar = true
    local base_config = {
      options = {
        theme = custom_theme,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = {
          "dbui",
          "DiffviewFiles",
          "DiffviewFileHistory",
          "fugitiveblame",
          "git",
        },
        globalstatus = true,
        disabled_filetypes = {
          winbar = utils.ignore_filetypes,
        },
      },
      extensions = { "man", "quickfix", git_extension },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = { tabs_config },
      },
      inactive_sections = {
        lualine_c = {},
      },
    }

    local merged_config = base_config
    if no_winbar then
      merged_config.options.globalstatus = false
      merged_config.options.disabled_filetypes = { "starter", "TelescopePrompt" }
      merged_config.sections.lualine_b = { winbar_filename_config }
      merged_config.inactive_sections.lualine_c = { winbar_filename_config }
      merged_config.sections.lualine_x = { "searchcount", winbar_filetype_config, "progress" }
    else
      merged_config.winbar = {
        lualine_a = {},
        lualine_b = { winbar_filetype_config },
        lualine_c = { winbar_filename_config, "diagnostics" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }
      merged_config.inactive_winbar = {
        lualine_a = {},
        lualine_b = { winbar_filename_config, "diagnostics" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      }
    end

    require("lualine").setup(merged_config)
  end,
}
