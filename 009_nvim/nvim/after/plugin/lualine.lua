require('lualine').setup({
    options = {
        disabled_filetypes = {
            statusline = { 'dbui' }
        },
        component_separators = { left = '╲', right = '╱' },
        section_separators = { left = '', right = '' },
    },
    extensions = { 'fugitive', 'nvim-tree' },
    sections = {
        lualine_b = {
            'diff',
            'diagnostics'
        },
    }
})
