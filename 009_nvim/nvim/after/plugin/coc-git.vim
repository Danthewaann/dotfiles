" Navigate chunks of current buffer
nmap [c <Plug>(coc-git-prevchunk)zz
nmap ]c <Plug>(coc-git-nextchunk)zz

" Open current line in browser
nmap <leader>go :call CocAction('runCommand', 'git.browserOpen')<CR>

" Undo chunk at current position
nmap cu :silent call CocAction('runCommand', 'git.chunkUndo')<CR>

" Show chunk diff at current position
nmap cp <Plug>(coc-git-chunkinfo)

" Hide git blame virtual text by default
let g:coc_git_hide_blame_virtual_text = 1

function! ToggleGitBlameVirtualText() abort
    let current = get(g:, 'coc_git_hide_blame_virtual_text', 0)
    if current == 0
        echo "Toggling git blame off"
    else
        echo "Toggling git blame on"
    endif
    let g:coc_git_hide_blame_virtual_text = !current
endfunction

" Toggle git blame virtual text
nnoremap <silent><leader>gb :call ToggleGitBlameVirtualText()<CR>
