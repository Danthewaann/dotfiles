" Returns true if the given file belongs to your test runner
function! test#go#make#test_file(file)
    if fnamemodify(a:file, ':t') =~# g:test#go#gotest#file_pattern
        if exists('g:test#go')
            return g:test#go#runner ==# 'make'
        else
            return executable("make") && !empty(glob("Makefile"))
        endif
    endif
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#go#make#build_position(type, position)
    return test#go#gotest#build_position(a:type, a:position)
endfunction

" Returns processed args (if you need to do any processing)
function! test#go#make#build_args(args)
    let build_args = test#go#gotest#build_args(a:args)
    if len(build_args) == 2
        let test = substitute(build_args[0], "-run ", "", "")
        let path = build_args[1]
        let args = ["test=" . test . " path=" . path ]
    else
        let test = ""
        let path = build_args[0]
        let args = ["path=" . path]
    endif
    return args
endfunction

" Returns the executable of your test runner
function! test#go#make#executable()
    return "make unit"
endfunction

" From https://github.com/vim-test/vim-test/issues/147#issuecomment-667483332
" Try to infer the test suite, so that :TestSuite works without opening a test file
if exists('g:test#last_position')
    finish
endif

let s:patterns = [
            \ { 'dir': './', 'pattern': '*_test.go'},
            \ ]

for s:p in s:patterns
    " gets the path of the first file that matches the dir/pattern
    let s:path = trim(system('find '.shellescape(s:p.dir).' -iname '.shellescape(s:p.pattern).' -print -quit 2> /dev/null'))
    if s:path !=# ''
        let g:test#last_position = {
                    \ 'file': s:path,
                    \ 'col': 1,
                    \ 'line': 1,
                    \}
        finish
    endif
endfor
