local telescope = require('telescope')

telescope.setup {
    defaults = {
        -- Cache the last 10 pickers so I can resume them later
        cache_picker = {
            num_pickers = 10,
            limit_entries = 1000
        },
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
        },
        file_ignore_patterns = {
            "vendor"
        },
        layout_strategy = 'horizontal',
        layout_config = { horizontal = { height = 0.9, width = 0.9, preview_width = 0.55 }},
    },
    pickers = {
        live_grep = {
            additional_args = function(opts)
                return {"--hidden"}
            end
        },
    },
}

-- From: https://github.com/nvim-telescope/telescope.nvim/issues/1923#issuecomment-1122642431
function vim.getVisualSelection()
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg('v')
    vim.fn.setreg('v', {})

    text = string.gsub(text, "\n", "")
    if #text > 0 then
        return text
    else
        return ''
    end
end

local function mergeTables(firstTable, secondTable)
    for k,v in pairs(secondTable) do firstTable[k] = v end
    return firstTable
end

local builtin = require('telescope.builtin')
local vertical_layout = { layout_strategy='vertical', layout_config={ height = 0.9, width = 0.9, preview_height = 0.6  } }

-- Resume last picker
vim.keymap.set('n', '<leader>tr', builtin.resume, {})

-- List previous pickers
vim.keymap.set('n', '<leader>tp', function() builtin.pickers(vertical_layout) end)

-- Search through all files in the current project
vim.keymap.set('n', '<C-p>', function()
    builtin.find_files({ hidden = true })
end)

-- Search through all git files in the current project
vim.keymap.set('n', '<C-f>', builtin.git_files, {})

-- List all open and hidden buffers
vim.keymap.set('n', '<leader>bb', function() builtin.buffers(vertical_layout) end)

-- List search history
vim.keymap.set('n', '<leader>sh', builtin.search_history, {})

-- List command history
vim.keymap.set('n', '<leader>ch', builtin.command_history, {})

-- Show changed git files in current project
vim.keymap.set('n', '<leader>gf', function() builtin.git_status(vertical_layout) end)

-- Show all git commits in current project
vim.keymap.set('n', '<leader>gl', function() builtin.git_commits(vertical_layout) end)

-- Search for pattern in current project files
vim.keymap.set('n', '<leader>ps', function()
    local ok, search = pcall(vim.fn.input, "Grep > ")
    if ok then
        builtin.grep_string(mergeTables({ search = search }, vertical_layout))
    end
end)

-- Search for the current word in project files
vim.keymap.set('n', '<leader>F', function() builtin.grep_string(vertical_layout) end);

-- Search for the current visual selection in project files
vim.keymap.set('v', '<leader>F', function()
    local test = vim.getVisualSelection()
    builtin.grep_string(mergeTables({ search = test }, vertical_layout))
end);

-- Do a live grep in the current project
vim.keymap.set('n', '<leader>lg', function() builtin.live_grep(vertical_layout) end);
