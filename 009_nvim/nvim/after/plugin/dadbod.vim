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

augroup dbui_au
    autocmd!
    " Unmap these as I use <C-J/K> for navigating windows
    autocmd FileType dbui unmap <buffer> <C-J>
    autocmd FileType dbui unmap <buffer> <C-K>

    " Unmap these as they are annoying
    autocmd FileType dbui unmap <buffer> <C-P>
    autocmd FileType dbui unmap <buffer> <C-N>

    " Use tab for opening drawers
    autocmd FileType dbui map <Tab> <Plug>(DBUI_SelectLine)
augroup END

augroup sql_au
    autocmd!
    " Execute the current sql buffer
    autocmd FileType sql map <leader>e <Plug>(DBUI_ExecuteQuery)
augroup END
