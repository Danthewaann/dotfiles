" Disable omnifunc for sql as it is annoying when I press <C-c> in insert mode
let g:omni_sql_no_default_maps = 1

" Use nerd fonts for the UI
let g:db_ui_use_nerd_fonts = 1

" Use a drawer with a bigger width
let g:db_ui_winwidth = 80

" Don't execute sql when saving an sql buffer
let g:db_ui_execute_on_save = 0

" Position the drawer on the right side of the window
let g:db_ui_win_position = 'right'

" Open DB connections window
nnoremap <silent><leader>db :tabnew<CR>:DBUI<CR>

" Unmap these as I use <C-J/K> for navigating windows
autocmd FileType dbui unmap <buffer> <C-J>
autocmd FileType dbui unmap <buffer> <C-K>

" Use tab for opening drawers
autocmd FileType dbui map <Tab> <Plug>(DBUI_SelectLine)

" Execute the current sql buffer
autocmd FileType sql map <leader>e <Plug>(DBUI_ExecuteQuery)
