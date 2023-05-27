" Navigate chunks of current buffer
nmap [c <Plug>(coc-git-prevchunk)zz
nmap ]c <Plug>(coc-git-nextchunk)zz

function! CocGitRefreshGitStatus(error = v:null, result = v:null) abort
    let win_id = win_getid()
    call RefreshGitStatus()
    call win_gotoid(win_id)
    execute 'e'
endfunction

" Git push binds
nmap <silent><leader>gpp :call CocActionAsync('runCommand', 'git.push', function('CocGitRefreshGitStatus'))<CR>
nmap <silent><leader>gpf :call CocActionAsync('runCommand', 'git.push', '--force', function('CocGitRefreshGitStatus'))<CR>

" Show chunks in current buffer
nmap <leader>gch :CocList gchunks<CR>

" Open current line in browser
nmap <leader>go :call CocAction('runCommand', 'git.browserOpen')<CR>

" Show diff of staged changes in current buffer
nmap <silent><leader>gd :call CocAction('runCommand', 'git.diffCached')<CR>

" Stage chunk at current position
nmap <silent><leader>gs :echo "Staging chunk..."<CR>:silent call CocActionAsync('runCommand', 'git.chunkStage', function('CocGitRefreshGitStatus'))<CR>

" Unstage chunk at current position
nmap <silent><leader>gu :echo "Unstaging chunk..."<CR>:silent call CocActionAsync('runCommand', 'git.chunkUnstage', function('CocGitRefreshGitStatus'))<CR>

" Undo chunk at current position
nmap cu :silent call CocActionAsync('runCommand', 'git.chunkUndo', function('CocGitRefreshGitStatus'))<CR>

" Show chunk diff at current position
nmap cp <Plug>(coc-git-chunkinfo)

" Create text object for git chunks
omap ic <Plug>(coc-git-chunk-inner)
xmap ic <Plug>(coc-git-chunk-inner)
omap ac <Plug>(coc-git-chunk-outer)
xmap ac <Plug>(coc-git-chunk-outer)

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
