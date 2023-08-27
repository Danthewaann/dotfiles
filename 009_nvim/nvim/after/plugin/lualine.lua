function is_floating(win_id) 
    local cfg = vim.api.nvim_win_get_config(win_id)
    if cfg.relative ~= "" or cfg.external then
        return true
    end
    return false
end

local winbar_filename_config = {
    'filename',
    -- cond = function()
    --     local windows = vim.api.nvim_tabpage_list_wins(0)
    --     local valid_win_count = 0
    --     for k, v in pairs(windows) do
    --         if not is_floating(v) then
    --             valid_win_count = valid_win_count + 1
    --         end
    --     end
    --     return valid_win_count > 1
    -- end,
    file_status = true,      -- Displays file status (readonly status, modified status)
    newfile_status = true,  -- Display new file status (new file means no write after created)
    path = 1,                -- 0: Just the filename
    -- 1: Relative path
    -- 2: Absolute path
    -- 3: Absolute path, with tilde as the home directory
    -- 4: Filename and parent dir, with tilde as the home directory

    shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
    -- for other components. (terrible name, any suggestions?)
    symbols = {
        modified = '[+]',      -- Text to show when the file is modified.
        readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
        unnamed = '', -- Text to show for unnamed buffers.
        newfile = '',     -- Text to show for newly created file before first write
    }
}

local winbar_filetype_config = {
    'filetype',
    colored = true,   -- Displays filetype icon in color if set to true
    icon_only = true, -- Display only an icon for filetype
    icon = { align = 'right' }, -- Display filetype icon on the right hand side
    -- icon =    {'X', align='right'}
    -- Icon string ^ in table is ignored in filetype component
}

require('lualine').setup({
    options = {
        component_separators = '',
        section_separators = { left = '', right = '' },
        ignore_focus = { "NvimTree", "dbui", "undotree", "TelescopePrompt"},
        globalstatus = true,
        disabled_filetypes = {
            winbar = { "qf", "fugitive", "dbui", "NvimTree", "undotree", "gitcommit", "GV", "packer", "", }
        },
    },
    extensions = { 'fugitive', 'nvim-tree', 'quickfix' },
    winbar = {
        lualine_a = {},
        lualine_b = {winbar_filename_config},
        lualine_c = {winbar_filetype_config},
        lualine_x = {'diagnostics'},
        lualine_y = {'diff'},
        lualine_z = {}
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = {winbar_filename_config},
        lualine_c = {winbar_filetype_config},
        lualine_x = {'diagnostics'},
        lualine_y = {'diff'},
        lualine_z = {}
    },
    sections = {
        lualine_b = {'branch'},
        lualine_c = {}
    },
    inactive_sections = {
        lualine_c = {}
    }
})
