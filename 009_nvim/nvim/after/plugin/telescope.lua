local builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-f>', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>bb', builtin.buffers, {})
vim.keymap.set('n', '<leader>hs', builtin.search_history, {})
vim.keymap.set('n', '<leader>hc', builtin.command_history, {})
vim.keymap.set('n', '<leader>gf', builtin.git_status, {})
vim.keymap.set('n', '<leader>gl', builtin.git_commits, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
