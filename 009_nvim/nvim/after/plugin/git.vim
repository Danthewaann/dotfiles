augroup fugitive_au
    autocmd!
    " Make sure the Git window height stays fixed
    autocmd FileType fugitive setlocal winfixheight
augroup END

augroup gv_au
    autocmd!
    " Make sure the Git window height stays fixed
    autocmd FileType GV map J j<CR>
    autocmd FileType GV map K k<CR>
augroup END
