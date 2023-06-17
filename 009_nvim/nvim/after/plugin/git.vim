augroup fugitive_au
    autocmd!
    " Make sure the Git window height stays fixed
    autocmd FileType fugitive setlocal winfixheight
augroup END

augroup gv_au
    autocmd!
    " Make sure the Git window height stays fixed
    autocmd FileType GV map J <C-n>
    autocmd FileType GV map K <C-p>
    autocmd FileType GV setlocal buftype=nofile bufhidden=wipe noswapfile nomodeline
augroup END
