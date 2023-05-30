local bufferline = require('bufferline')

bufferline.setup({
    highlights = {
        fill = {
            fg = '#abb2bf',
            bg = '#31353f',
        },
        background = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        tab = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        tab_selected = {
            bg = '#98c379'
        },
        tab_separator = {
            bg = '#3b3f4c',
        },
        tab_separator_selected = {
            bg = '#98c379',
        },
        tab_close = {
            fg = '#abb2bf',
            bg = '#31353f',
        },
        close_button = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        close_button_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        close_button_selected = {
            bg = '#98c379'
        },
        buffer_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        buffer_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        numbers = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        numbers_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        numbers_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        diagnostic = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        diagnostic_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        diagnostic_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        hint = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        hint_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        hint_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        hint_diagnostic = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        hint_diagnostic_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        hint_diagnostic_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        info = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        info_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        info_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        info_diagnostic = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        info_diagnostic_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        info_diagnostic_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        warning = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        warning_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        warning_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        warning_diagnostic = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        warning_diagnostic_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        warning_diagnostic_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        error = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        error_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        error_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        error_diagnostic = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        error_diagnostic_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        error_diagnostic_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        modified = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        modified_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        modified_selected = {
            fg = '#282c34',
            bg = '#98c379'
        },
        duplicate = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
            italic = true
        },
        duplicate_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
            italic = true
        },
        duplicate_selected = {
            fg = '#282c34',
            bg = '#98c379',
            italic = true,
        },
        separator = {
            fg = '#31353f',
            bg = '#3b3f4c',
        },
        separator_visible = {
            fg = '#31353f',
            bg = '#3b3f4c',
        },
        separator_selected = {
            fg = '#31353f',
            bg = '#98c379'
        },
        indicator_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
        },
        indicator_selected = {
            fg = '#282c34',
            bg = '#98c379'
        },
        pick = {
            fg = '#31353f',
            bg = '#3b3f4c',
            bold = true,
            italic = true,
        },
        pick_visible = {
            fg = '#abb2bf',
            bg = '#3b3f4c',
            bold = true,
            italic = true,
        },
        pick_selected = {
            fg = '#282c34',
            bg = '#98c379',
            bold = true,
            italic = true,
        },
        offset_separator = {
            fg = '#31353f',
            bg = '#31353f',
        },
    },
    options = {
        separator_style = "slope",
        themable = true,
        mode = "tabs", -- set to "tabs" to only show tabpages instead
        themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
        numbers = "ordinal",
        close_command = "bdelete! %d",       -- can be a string | function, | false see "Mouse actions"
        right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
        left_mouse_command = "buffer %d",    -- can be a string | function, | false see "Mouse actions"
        middle_mouse_command = nil,          -- can be a string | function, | false see "Mouse actions"
        indicator = {
            style = 'none',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = false, -- whether or not tab names should be truncated
        tab_size = 0,
        diagnostics = "coc",
        diagnostics_update_in_insert = false,
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "left",
                separator = true
            },
            {
                filetype = "dbui",
                text = "DB Explorer",
                text_align = "left",
                separator = true
            }
        },
        show_buffer_icons = false, -- disable filetype icons for buffers
        color_icons = false, -- whether or not to add the filetype icon highlights
    }
})
