require('lualine').setup({
    options = {
        disabled_filetypes = {
            statusline = { "NvimTree", "fugitive", "dbui" }
        },
        component_separators = { left = '╲', right = '╱' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_b = {
            'diff',
            'diagnostics'
        },
    }
})
