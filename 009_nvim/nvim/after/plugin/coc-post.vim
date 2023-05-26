function Post() abort
    if &filetype != 'post'
        echohl WarningMsg
        echo "Can only run :Post in a .post file!"
        echohl None
        return
    endif

    let changed_post_file = 0
    let post_buf = win_getid()

    " If this post file requires an API_KEY, make sure to set it
    let api_key_line = search('@API_KEY@')
    if api_key_line != 0
        let coc_post_api_key = trim(system("cat ~/.coc-post-api-key"))
        if v:shell_error || empty(coc_post_api_key)
            echohl WarningMsg
            echo "This post file requires an API_KEY"
            echohl None
            return
        endif
        execute api_key_line . ' s/@API_KEY@/' . coc_post_api_key . '/g'
        execute 'w'
        let changed_post_file = 1
    endif

    " Run the post file
    execute 'CocCommand post.do'

    " Make sure the post output window is visible before proceeding
    let timeout = 10
    let cur_buf = win_getid()
    while timeout > 0 && cur_buf == post_buf
        sleep 100ms
        let timeout = timeout - 1
        let cur_buf = win_getid()
    endwhile

    " Make sure the request body has been displayed before proceeding
    let timeout = 10
    while timeout > 0 && search("Body") == 0
        sleep 1000ms
        let timeout = timeout - 1
    endwhile

    " If there is an apiKey in the body, use it for future requests
    let api_key = search("apiKey")
    if api_key != 0
        let line = trim(split(getline(api_key), ":")[1])
        let line = substitute(line, '"', '', 'g')
        let line = substitute(line, ',', '', 'g')
        call system("echo " . line . " > ~/.coc-post-api-key")
    endif

    if changed_post_file == 1
        " Go back to the post file to undo our changes
        call win_gotoid(post_buf)
        execute 'u'
        execute 'w'
    endif
endfunction

" Run current post file
command! -nargs=0 Post call Post()

" Show all post files
nnoremap <silent><leader>pl :CocList post<CR>

" Execute current post file
nnoremap <silent><leader>pp :Post<CR>
