" Close the current buffer without closing the window
nnoremap <silent><leader>bd :Bdelete<CR>

" Delete all buffers except the current one
"
" From https://stackoverflow.com/questions/4545275/vim-close-all-buffers-but-this-one
command! BufOnly silent! execute "%bd|e#|bd#"
nnoremap <silent><leader>bo :BufOnly<CR>:echo "Deleted all buffers"<CR>

" Delete all(saved) but visible buffers
"
" From https://vi.stackexchange.com/a/27106
function! Delete_buffers() abort
    " All visible buffers in all tabs
    let buflist = []
    for i in range(tabpagenr('$'))
        call extend(buflist, tabpagebuflist(i + 1))
    endfor

    " All existing buffers
    for bnr in range(1, bufnr("$"))
        if index(buflist, bnr) == -1 && buflisted(bnr)
            execute 'bdelete ' . bnr
        endif
    endfor
endfunction

" Kill-all but visible buffers
nnoremap <silent> <leader>bda :call Delete_buffers()<CR>:echo "Non-windowed buffers are deleted"<CR>
