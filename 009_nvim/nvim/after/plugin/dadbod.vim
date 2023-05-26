" Use nerd fonts for the UI
let g:db_ui_use_nerd_fonts = 1

" Use a drawer with a bigger width
let g:db_ui_winwidth = 80

" Open DB connections window
nnoremap <silent><leader>db :tabnew<CR>:DBUI<CR>

" Unmap these as I use <C-J/K> for navigating windows
autocmd FileType dbui unmap <buffer> <C-J>
autocmd FileType dbui unmap <buffer> <C-K>

" Use tab for opening drawers
autocmd FileType dbui map <Tab> <Plug>(DBUI_SelectLine)
