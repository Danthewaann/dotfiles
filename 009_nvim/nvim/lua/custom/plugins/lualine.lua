return {
  -- Set lualine as statusline
  "nvim-lualine/lualine.nvim",
  -- See `:help lualine.txt`
  config = function()
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

    local function tabline_formatter(result, context)
      if context.filetype == "fugitive" then
        return "[Git Status]"
      end
      if context.filetype == "aerial" then
        return "[Aerial]"
      end

      if string.match(context.file, "--follow") or string.match(context.file, "-L") then
        return string.format("[Git Log] %s", result)
      elseif string.match(context.file, "--graph") then
        return "[Git Log]"
      elseif context.filetype == "DiffviewFiles" then
        return "[Diff View]"
      end

      return result
    end

    local tabline_buffers_config = {
      "buffers",
      icons_enabled = true,
      show_filename_only = true,       -- Shows shortened relative path when set to false.
      hide_filename_extension = false, -- Hide filename extension when set to true.
      show_modified_status = true,     -- Shows indicator when the buffer is modified.

      mode = 2,                        -- 0: Shows buffer name
      -- 1: Shows buffer index
      -- 2: Shows buffer name + buffer index
      -- 3: Shows buffer number
      -- 4: Shows buffer name + buffer number
      fmt = tabline_formatter,

      max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
      -- it can also be a function that returns
      -- the value of `max_length` dynamically.
      filetype_names = {
        TelescopePrompt = "Telescope",
        dashboard = "Dashboard",
        packer = "Packer",
        fzf = "FZF",
        alpha = "Alpha",
        oil = "File Explorer",
        dbui = "DB Explorer",
      }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

      -- Automatically updates active buffer color to match color of other components (will be overridden if buffers_color is set)
      use_mode_colors = false,

      symbols = {
        modified = " [+]", -- Text to show when the buffer is modified
        alternate_file = "#", -- Text to show to identify the alternate file
        directory = "", -- Text to show when the buffer is a directory
      },
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
        readonly = "",         -- Text to show when the file is non-modifiable or readonly.
        unnamed = "[No Name]", -- Text to show for unnamed buffers.
        newfile = "[New]",     -- Text to show for newly created file before first write
      },
    }

    local winbar_filetype_config = {
      "filetype",
      colored = true,             -- Displays filetype icon in color if set to true
      icon_only = false,          -- Display only an icon for filetype
      icon = { align = "right" }, -- Display filetype icon on the right hand side
      -- icon =    {'X', align='right'}
      -- Icon string ^ in table is ignored in filetype component
    }

    require("lualine").setup({
      options = {
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        ignore_focus = { "NvimTree", "dbui", "undotree", "TelescopePrompt" },
        globalstatus = true,
        disabled_filetypes = {
          winbar = {
            "qf",
            "git",
            "fugitive",
            "fugitiveblame",
            "dbui",
            "NvimTree",
            "undotree",
            "diff",
            "gitcommit",
            "GV",
            "packer",
            "list",
            "help",
            "man",
            "spectre_panel",
            "dbout",
            "DiffviewFiles",
            "DiffviewFileHistory",
            "oil",
            "aerial",
            "Trouble",
          },
        },
      },
      extensions = { "fugitive", "nvim-tree", "quickfix", "aerial" },
      winbar = {
        lualine_a = {},
        lualine_b = { winbar_filetype_config },
        lualine_c = { winbar_filename_config, "diff", "diagnostics" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = { winbar_filename_config, "diff", "diagnostics" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(mode)
              return vim.b["visual_multi"] and mode .. " - MULTI" or mode
            end
          },
        },
        lualine_b = { "branch" },
        lualine_c = {
          {
            -- From: https://github.com/nvim-lualine/lualine.nvim/issues/951
            function()
              if vim.b["visual_multi"] then
                local ret = vim.api.nvim_exec2("call b:VM_Selection.Funcs.infoline()", { output = true })
                return string.match(ret.output, "M.*")
              else
                return ""
              end
            end
          }
        },
        lualine_x = { "searchcount", "encoding", "fileformat" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = {
          {
            "tabs",
            tab_max_length = 40,            -- Maximum width of each tab. The content will be shorten dynamically (example: apple/orange -> a/orange)
            max_length = vim.o.columns / 3, -- Maximum width of tabs component.
            -- Note:
            -- It can also be a function that returns
            -- the value of `max_length` dynamically.
            mode = 0, -- 0: Shows tab_nr
            -- 1: Shows tab_name
            -- 2: Shows tab_nr + tab_name

            path = 0, -- 0: just shows the filename
            -- 1: shows the relative path and shorten $HOME to ~
            -- 2: shows the full path
            -- 3: shows the full path and shorten $HOME to ~

            -- Automatically updates active tab color to match color of other components (will be overidden if buffers_color is set)
            use_mode_colors = false,

            show_modified_status = true, -- Shows a symbol next to the tab name if the file has been modified.
            symbols = {
              modified = "",          -- Text to show when the file is modified.
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
        },
      },
      inactive_sections = {
        lualine_c = {},
      },
    })
  end,
}
