return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local bufferline = require("bufferline")

    local fg_colour_inactive = "#abb2bf"
    local bg_colour_inactive = "#3b3f4c"

    local fg_colour_active = "#282c34"
    local bg_colour_active = "#98c379"

    local fg_colour = "#31353f"
    local bg_colour = "#31353f"

    local onedark_highlights = {
      fill = {
        fg = fg_colour_inactive,
        bg = bg_colour,
      },
      background = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      tab = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      tab_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
      },
      tab_separator = {
        fg = fg_colour_active,
        bg = bg_colour_inactive,
      },
      tab_separator_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
      },
      tab_close = {
        fg = fg_colour_inactive,
        bg = bg_colour,
      },
      close_button = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      close_button_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      close_button_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
      },
      buffer_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      buffer_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      numbers = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      numbers_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      numbers_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      diagnostic = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      diagnostic_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      diagnostic_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      hint = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      hint_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      hint_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      hint_diagnostic = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      hint_diagnostic_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      hint_diagnostic_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      info = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      info_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      info_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      info_diagnostic = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      info_diagnostic_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      info_diagnostic_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      warning = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      warning_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      warning_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      warning_diagnostic = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      warning_diagnostic_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      warning_diagnostic_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      error = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      error_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      error_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      error_diagnostic = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      error_diagnostic_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      error_diagnostic_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      modified = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      modified_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      modified_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
      },
      duplicate = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
        italic = true,
      },
      duplicate_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
        italic = true,
      },
      duplicate_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        italic = true,
      },
      separator = {
        fg = fg_colour,
        bg = bg_colour_inactive,
      },
      separator_visible = {
        fg = fg_colour,
        bg = bg_colour_inactive,
      },
      separator_selected = {
        fg = fg_colour,
        bg = bg_colour_active,
      },
      indicator_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
      },
      indicator_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
      },
      pick = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
        bold = true,
        italic = true,
      },
      pick_visible = {
        fg = fg_colour_inactive,
        bg = bg_colour_inactive,
        bold = true,
        italic = true,
      },
      pick_selected = {
        fg = fg_colour_active,
        bg = bg_colour_active,
        bold = true,
        italic = true,
      },
      offset_separator = {
        fg = fg_colour,
        bg = bg_colour,
      },
    }

    local onedark_minimal_highlights = {
      fill = {
        fg = fg_colour_inactive,
        bg = bg_colour,
      },
      tab_close = {
        fg = fg_colour_inactive,
        bg = bg_colour,
      },
      offset_separator = {
        fg = fg_colour,
        bg = bg_colour,
      },
    }

    ---@diagnostic disable-next-line: missing-fields
    bufferline.setup({
      ---@diagnostic disable-next-line: missing-fields
      options = {
        style_preset = bufferline.style_preset.minimal,
        separator_style = { "", "" },
        mode = "tabs", -- set to "tabs" to only show tabpages instead
        themable = false, -- allows highlight groups to be overridden i.e. sets highlights as default
        numbers = "ordinal",
        close_command = "bdelete! %d", -- can be a string | function, | false see "Mouse actions"
        right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, | false see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
        indicator = {
          style = "none",
        },
        buffer_close_icon = "",
        modified_icon = "",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        --- name_formatter can be used to change the buffer's label in the bufferline.
        --- Please note some names can/will break the
        --- bufferline so use this at your discretion knowing that it has
        --- some limitations that will *NOT* be fixed.
        name_formatter = function(buf) -- buf contains:
          -- name                | str        | the basename of the active file
          -- path                | str        | the full path of the active file
          -- bufnr (buffer only) | int        | the number of the active buffer
          -- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
          -- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
          --
          -- Just output the terminal command if this is a terminal job
          if string.match(buf.path, "term:.*:.*") then
            local t = {}
            for i in string.gmatch(buf.path, "([^:]+)") do
              t[#t + 1] = i
            end
            -- Remove the term path and port to only include the make command in the tabline
            return unpack(t, 3)
          elseif string.match(buf.path, "--follow") or string.match(buf.path, "-L") then
            return string.format("[Git log] %s", buf.name)
          elseif string.match(buf.path, "--graph") then
            return "[Git log]"
          elseif string.match(buf.path, "DiffviewFilePanel") then
            return "Diff View"
          end
        end,
        -- NOTE: this will be called a lot so don't do any heavy processing here
        custom_filter = function(buf_number, buf_numbers)
          -- filter out filetypes you don't want to see
          local file_type = vim.bo[buf_number].filetype
          if
            file_type == "fugitive"
            or file_type == "NvimTree"
            or file_type == "dbui"
            or file_type == "qf"
            or file_type == "undotree"
          then
            return false
          end
          -- -- filter out by buffer name
          -- if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
          --     return true
          -- end
          -- -- filter out based on arbitrary rules
          -- -- e.g. filter out vim wiki buffer from tabline in your work repo
          -- if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
          --     return true
          -- end
          -- -- filter out by it's index number in list (don't show first buffer)
          -- if buf_numbers[1] ~= buf_number then
          --     return true
          -- end
        end,
        max_name_length = 25,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = false, -- whether or not tab names should be truncated
        tab_size = 0,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = true,
        --- count is an integer representing total count of errors
        --- level is a string "error" | "warning"
        --- this should return a string
        --- Don't get too fancy as this function will be executed a lot
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or ""
          return icon
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
          },
          {
            filetype = "dbui",
            text = "DB Explorer",
            text_align = "left",
            separator = true,
          },
          {
            filetype = "undotree",
            text = "Undotree",
            text_align = "left",
            separator = true,
          },
          {
            filetype = "DiffviewFiles",
            text = "Diff View",
            text_align = "left",
            separator = true,
          },
        },
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_duplicate_prefix = false, -- whether to show duplicate buffer prefix
        color_icons = true, -- whether or not to add the filetype icon highlights
        always_show_bufferline = false,
      },
    })
  end,
}
