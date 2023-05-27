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

local builtin = require('telescope.builtin')

-- Resume last picker
vim.keymap.set('n', '<leader>rl', builtin.resume, {})

-- List previous pickers
vim.keymap.set('n', '<leader>l', builtin.pickers, {})

-- Search through all files in the current project
vim.keymap.set('n', '<C-f>', builtin.find_files, {})

-- Search through all git files in the current project
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

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
