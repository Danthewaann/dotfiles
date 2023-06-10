local telescope = require('telescope')

telescope.setup {
    defaults = {
        -- Cache the last 10 pickers so I can resume them later
        cache_picker = {
            num_pickers = 10,
            limit_entries = 1000
        }
    }
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

local builtin = require('telescope.builtin')

-- Resume last picker
vim.keymap.set('n', '<leader>lr', builtin.resume, {})

-- List previous pickers
vim.keymap.set('n', '<leader>lp', builtin.pickers, {})

-- Search through all files in the current project
vim.keymap.set('n', '<C-p>', function()
    builtin.find_files({ hidden = true })
end)

-- Search through all git files in the current project
vim.keymap.set('n', '<C-f>', builtin.git_files, {})

-- List all open and hidden buffers
vim.keymap.set('n', '<leader>bb', builtin.buffers, {})

-- List search history
vim.keymap.set('n', '<leader>hs', builtin.search_history, {})

-- List command history
vim.keymap.set('n', '<leader>hc', builtin.command_history, {})

-- Show changed git files in current project
vim.keymap.set('n', '<leader>gf', builtin.git_status, {})

-- Show all git commits in current project
vim.keymap.set('n', '<leader>gl', builtin.git_commits, {})

-- Search for pattern in current project files
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

-- Search for the current word in project files
vim.keymap.set('n', '<leader>F', builtin.grep_string, {});

-- Search for the current visual selection in project files
vim.keymap.set('v', '<leader>F', function()
    local test = vim.getVisualSelection()
    builtin.grep_string({ search = test })
end);

-- Do a live grep in the current project
vim.keymap.set('n', '<leader>lg', builtin.live_grep, {});
