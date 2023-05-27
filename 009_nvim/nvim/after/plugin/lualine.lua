require('lualine').setup({
    options = {
        disabled_filetypes = {
            statusline = { "NvimTree" }
        }
    },
    sections = {
        lualine_b = {
            {
                'diff',
                colored = true, -- Displays a colored diff status if set to true
                diff_color = {
                    -- Same color values as the general color option can be used here.
                    added    = 'GitGutterAdd',    -- Changes the diff's added color
                    modified = 'GitGutterChange', -- Changes the diff's modified color
                    removed  = 'GitGutterDelete', -- Changes the diff's removed color you
                },
                symbols = {added = '+', modified = '~', removed = '-'}, -- Changes the symbols used by the diff.
                source = nil, -- A function that works as a data source for diff.
                -- It must return a table as such:
                --   { added = add_count, modified = modified_count, removed = removed_count }
                -- or nil on failure. count <= 0 won't be displayed.
            }
        },
    }
})
