local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

augroup("highlight_cursorline", { clear = true })
autocmd("InsertEnter", {
    group = "highlight_cursorline",
    pattern = "",
    command = "set cursorline",
})
autocmd("InsertLeave", {
    group = "highlight_cursorline",
    pattern = "",
    command = "set nocursorline",
})

augroup("terminal_settings", { clear = true })
autocmd("TermOpen", {
    group = "terminal_settings",
    pattern = "",
    command = "setlocal nowrap nonumber norelativenumber signcolumn=no",
})
