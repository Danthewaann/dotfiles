vim.cmd[[
    " Custom stuff for adding breakpoint() statements
    "
    " Partially from https://gist.github.com/berinhard/523420
    func! s:GetLineContentAndWhitespace(line_num)
    let cur_line_content = getline(a:line_num)
    let cur_line_whitespace = strlen(matchstr(cur_line_content, '^\s*'))
    return {'content': cur_line_content, 'whitespace': cur_line_whitespace}
    endf

    func! s:GetBreakpointStmt()
        if &filetype == 'python'
            return 'breakpoint()'
        elseif &filetype == 'go'
            return 'runtime.Breakpoint()'
        endif
        return v:null
    endf

    func! s:GetWhiteSpaceChar()
        if &filetype == 'python'
            return ' '
        elseif &filetype == 'go'
            return '	'
        endif
        return v:null
    endf

    func! s:SetBreakpoint()
        let cur_line_num = line('.')
        let cur_line = s:GetLineContentAndWhitespace(cur_line_num)

        " Check the next line first to see if it is indented more than the current line
        " if it is, use the indentation level of that line
        " otherwise go through all previous lines to get the correct indentation level
        let next_line = s:GetLineContentAndWhitespace(cur_line_num+1)
        if strlen(cur_line['whitespace']) > 0 && next_line['whitespace'] > cur_line['whitespace']
            let cur_line['whitespace'] = next_line['whitespace']
        else
            while cur_line['whitespace'] == 0
                if cur_line_num == 0
                    break
                endif
                let cur_line_num = cur_line_num-1
                let cur_line = s:GetLineContentAndWhitespace(cur_line_num)
            endwhile

            " Check if the next line is indented more than the current line
            " if it is, use the indentation level of that line
            let next_line = s:GetLineContentAndWhitespace(cur_line_num+1)
            if strlen(cur_line['whitespace']) > 0 && next_line['whitespace'] > cur_line['whitespace']
                let cur_line['whitespace'] = next_line['whitespace']
            endif
        endif

        let breakpoint_stmt = s:GetBreakpointStmt()
        let whitespace_char = s:GetWhiteSpaceChar()
        if breakpoint_stmt == v:null || whitespace_char == v:null
            echohl WarningMsg
            echo "File not supported for breakpoints!"
            echohl None
            return
        endif

        cal append('.', repeat(whitespace_char, cur_line['whitespace']) . breakpoint_stmt)
    endf
            
    func! s:RemoveBreakpoint()
        let breakpoint_stmt = s:GetBreakpointStmt()
        exe 'silent! g/^\s*' . breakpoint_stmt . '/d'
    endf

    func! s:ToggleBreakpoint()
        let breakpoint_stmt = s:GetBreakpointStmt()
        if getline('.')=~#'^\s*' . breakpoint_stmt | cal s:RemoveBreakpoint() | el | cal s:SetBreakpoint() | en
    endf

    nnoremap <silent> <leader>bp :call <SID>ToggleBreakpoint()<CR>

    " From https://elliotekj.com/posts/2016/11/22/setup-ctrlp-to-use-ripgrep-in-vim/
    set grepprg=rg\ --vimgrep\ --color=never

    " From https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
    "
    " Setup a way to keep track of breakpoint() calls in Python code
    function! GetAllBreakpoints()
        let breakpoints = ""
        if &filetype == 'python'
            let breakpoints = system(join([&grepprg] + [' breakpoint\(\) -g "*.py" ./'], ' '))
        elseif &filetype == 'go'
            let breakpoints = system(join([&grepprg] + [' runtime.Breakpoint\(\) -g "*.go" ./'], ' '))
        endif

        if empty(breakpoints)
            echohl WarningMsg
            echo "No breakpoint()s found"
            echohl None
        endif
        return breakpoints
    endfunction

    function! DeleteAllBreakpoints()
        let breakpoints = GetAllBreakpoints()
        let list = split(breakpoints, '\n')
        let files = []
        if len(list) > 0
            echo "Deleting all breakpoint()s"
            sleep 150m
        endif
        let breakpoint_stmt = shellescape(s:GetBreakpointStmt())
        for item in list
            let file = split(item, ':')[0]
            if index(files, file) < 0
                call add(files, file)
                call system('sed -i -e /' . breakpoint_stmt . '/d ' . file)
                let file_extension = expand(file . ':e')
                " Remove the `runtime` import in go files
                if file_extension =~# "go"
                    call system('sed -i -e /"runtime"/d ' . file)
                endif
            endif
        endfor
    endfunction

    command! -nargs=0 DeleteAllBreakpoints call DeleteAllBreakpoints()
    command! -nargs=0 Breakpoints lgetexpr GetAllBreakpoints() | call setloclist(0, [], 'a', {'title': 'PythonBreakpoints'})

    " Delete all Python breakpoints
    nnoremap <silent> dab :DeleteAllBreakpoints<CR>

    augroup quickfix
        autocmd!
        autocmd QuickFixCmdPost cgetexpr cwindow
        autocmd QuickFixCmdPost lgetexpr lwindow
    augroup END
]]
