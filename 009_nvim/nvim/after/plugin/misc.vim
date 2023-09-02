" Use <C-P> and <C-N> to cycle through history in vim command mode
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Allow easier navigation in command mode
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-H> <Left>
cnoremap <C-L> <Right>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" Inspired from https://vi.stackexchange.com/questions/3951/deleting-in-vim-and-then-pasting-without-new-line
function! PasteInLine() abort
    let line = trim(getreg('*'))
    execute 'normal gv"_di' . line
endfunction

" Paste yanked line without line breaks before/after cursor position
vnoremap <silent> gp :call PasteInLine()<CR>

" Run a command in a terminal in a new tab
function RunCmdInTerminal(cmd, pos, ...) abort
    execute a:pos . ' new'
    if !empty(a:000)
        let cmd = [a:cmd] + a:000
        let name = a:cmd . ' ' . join(a:000)
    else
        let cmd = [a:cmd]
        let name = a:cmd
    endif
    let job_id = termopen(cmd)
    execute 'keepalt file [' . job_id . '] ' . name
    au BufDelete <buffer> wincmd p
endfunction

" Commands to run make commands in a terminal
command! -nargs=* Make :call RunCmdInTerminal('make', "$tab", <f-args>)
command! -nargs=* SMake :call RunCmdInTerminal('make', "20 split", <f-args>)
command! -nargs=* VMake :call RunCmdInTerminal('make', "100 vsplit", <f-args>)

function RunCmd(pos, ...) abort
    execute a:pos . ' new'
    if !empty(a:000)
        let cmd = a:000
        let name = join(a:000)
    else
        let cmd = [a:cmd]
        let name = a:cmd
    endif
    let job_id = termopen(cmd)
    execute 'keepalt file [' . job_id . '] ' . name
    au BufDelete <buffer> wincmd p
endfunction

command! -nargs=* Run :call RunCmd("$tab", <f-args>)

function RunLinting(pos) abort
    if !empty(glob("poetry.lock"))
        let cmd = ["poetry", "run"]
    else
        echohl ErrorMsg
        echo "Not supported"
        echohl None
        return
    end

    if !empty(glob("scripts/lint.sh"))
        let file = ["scripts/lint.sh"]
    else
        echohl ErrorMsg
        echo "Not supported"
        echohl None
        return
    end

    execute a:pos . ' new'
    let cmd = cmd + file
    let job_id = termopen(cmd)
    execute 'keepalt file [' . job_id . '] ' . "Linting"
    au BufDelete <buffer> wincmd p
endfunction

nnoremap <silent> <leader>rl :call RunLinting("$tab")<CR>

" Useful make commands
nnoremap <silent> <leader>ml :Make lint<CR>
nnoremap <silent> <leader>mt :Make test<CR>
nnoremap <silent> <leader>ms :Make shell<CR>

function! GetTicketNumber() abort
    return trim(system('get-ticket-number'))
endfunction

function! ReplaceTicketNumberInPRFile() abort
    let ticket_number = GetTicketNumber()
    if v:shell_error != 0
        echohl WarningMsg
        echo ticket_number
        echohl None
    else
        try
            execute '%s/TICKET_NUMBER/' . ticket_number . '/g'
        catch
            echohl ErrorMsg
            echo 'TICKET_NUMBER pattern not found in file!'
            echohl None
        endtry
    endif
endfunction

command! -nargs=0 ReplaceTicketNumberInPRFile :call ReplaceTicketNumberInPRFile()

" Automatically replace the ticket number in a PR markdown file created with
" the `git-pr-create` script
augroup replace_ticket_number_in_pr_file
    autocmd!
    autocmd BufEnter *.md if expand('$GIT_PR_CREATE_RAN') == 1 | call ReplaceTicketNumberInPRFile() | endif
augroup END

" Generate docstring for def or class on current line
nnoremap <silent> <leader>ds :Docstring<CR>
