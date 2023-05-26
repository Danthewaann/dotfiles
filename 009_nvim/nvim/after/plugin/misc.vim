" Use <C-P> and <C-N> to cycle through history in vim command mode
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Inspired from https://vi.stackexchange.com/questions/3951/deleting-in-vim-and-then-pasting-without-new-line
function! PasteInLine(before = v:true, visual = v:false) abort
    let line = trim(getreg('*'))
    if a:visual
        execute 'normal gv' . '"kdi' . line
    else
        let mode = "a"
        if a:before
            let mode = "i"
        endif
        execute "normal! " . mode . line . "\<Esc>"
    endif
endfunction

" Paste yanked line without line breaks before/after cursor position
nnoremap <silent> gP :call PasteInLine()<CR>
nnoremap <silent> gp :call PasteInLine(v:false)<CR>
vnoremap <silent> gp :call PasteInLine(v:false, v:true)<CR>

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
    call termopen(cmd)
    au BufDelete <buffer> wincmd p
    nnoremap <buffer> <Enter> :q<CR>
    echo "Press <Enter> to exit terminal (<Ctrl-C> first if command is still running)"
endfunction

" Commands to run make commands in a terminal
command! -nargs=* Make :call RunCmdInTerminal('make', "$tab", <f-args>)
command! -nargs=* SMake :call RunCmdInTerminal('make', "20 split", <f-args>)
command! -nargs=* VMake :call RunCmdInTerminal('make', "100 vsplit", <f-args>)

" Useful make commands
nnoremap <leader>ml :Make lint<CR>
nnoremap <leader>mt :Make test<CR>
nnoremap <leader>ms :Make shell<CR>

" Run Rg in a terminal window as a job
command! -nargs=* Search call RunCmdInTerminal(
            \"rg", 
            \"tab$", 
            \"--hidden", 
            \"--column",
            \"--line-number",
            \"--no-heading", 
            \"--color=always",
            \"--smart-case", 
            \"--", 
            \<q-args>,
            \)

function! RefreshGitStatus() abort
    for l:winnr in range(1, winnr('$'))
        if getwinvar(l:winnr, '&filetype') == "fugitive"
            execute 'Git'
            return v:true
        endif
    endfor
    return v:false
endfunction

augroup fugitive_au
    autocmd!
    " Make sure the Git window height stays fixed
    autocmd FileType fugitive setlocal winfixheight
augroup END

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
        execute '%s/TICKET_NUMBER/' . ticket_number . '/g'
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

" Disable matchit as I don't use it
let g:conflict_marker_enable_matchit = 0

let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1
let g:tslime_autoset_pane = 1
let g:tslime_pre_command = "C-c"
