let test#strategy = "neovim"
let test#neovim#term_position = '$tab'
let test#custom_runners = {'python': ['make'], 'go': ['make']}

if executable("make") && !empty(glob("Makefile"))
    let test#python#runner = 'make'
    let test#go#runner = 'make'
else
    let test#python#runner = 'pytest'
    let test#go#runner = 'gotest'
endif

let g:test#neovim#start_normal = 0

function! MyGetPosition(path) abort
    let filename_modifier = get(g:, 'test#filename_modifier', ':.')
    let position = {}
    let position['file'] = fnamemodify(a:path, filename_modifier)
    let position['line'] = a:path == expand('%') ? line('.') : 1
    let position['col']  = a:path == expand('%') ? col('.') : 1
    return position
endfunction

function! MyDebugNearest() abort
    let position = MyGetPosition(expand("%"))
    let runner = test#determine_runner(position['file'])
    if empty(runner)
        echohl WarningMsg
        echo "Not a test file"
        echohl None
        return
    endif
    let lang = split(runner, '#')[0]
    let build_args = test#{runner}#build_position("nearest", position)
    if lang == 'go'
        " Need to reverse the build args for `delve test`
        " e.g. `-run 'TestCheckWebsites$' .pkg/concurrency` to
        " `.pkg/concurrency -- -run 'TestCheckWebsites$'`
        let args = build_args[1] . ' -- ' . build_args[0]
    else
        let args = join(build_args)
    endif

    let runner_type = get(g:, 'test#python#runner', 'pytest')
    if lang == 'python' && runner_type == 'make'
        call vimspector#LaunchWithSettings({'configuration': 'python - remote test launch', 'args': args})
        return
    endif

    let runner_type = get(g:, 'test#go#runner', 'gotest')
    if lang == 'go' && runner_type == 'make'
        call vimspector#LaunchWithSettings({'configuration': 'go - remote test launch', 'args': args})
        return 
    endif

    call vimspector#LaunchWithSettings({'configuration': lang . ' - debug test', 'args': args})
endfunction

nnoremap <silent> <leader>dn :call MyDebugNearest()<CR>
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tc :TestClass<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>zz
