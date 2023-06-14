" Custom stuff for adding breakpoint() statements
"
" Partially from https://gist.github.com/berinhard/523420
func! s:GetLineContentAndWhitespace(line_num)
    let cur_line_content = getline(a:line_num)
    let cur_line_whitespace = strlen(matchstr(cur_line_content, '^\s*'))
    return {'content': cur_line_content, 'whitespace': cur_line_whitespace}
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
    cal append('.', repeat(' ', cur_line['whitespace']) . 'breakpoint()')
endf

func! s:RemoveBreakpoint()
    exe 'silent! g/^\s*breakpoint()/d'
endf

func! s:ToggleBreakpoint()
    if getline('.')=~#'^\s*breakpoint()' | cal s:RemoveBreakpoint() | el | cal s:SetBreakpoint() | en
endf

nnoremap <silent> gb :call <SID>ToggleBreakpoint()<CR>

" From https://elliotekj.com/posts/2016/11/22/setup-ctrlp-to-use-ripgrep-in-vim/
set grepprg=rg\ --vimgrep\ --color=never

" From https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
"
" Setup a way to keep track of breakpoint() calls in Python code
function! GetAllBreakpoints()
    let breakpoints = system(join([&grepprg] + [' breakpoint\(\) -g "*.py" ./'], ' '))
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
    for item in list
        let file = split(item, ':')[0]
        if index(files, file) < 0
            call add(files, file)
            call system('sed -i -e /breakpoint\(\)/d ' . file)
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
