" Returns true if the given file belongs to your test runner
function! test#python#make#test_file(file)
    if fnamemodify(a:file, ':t') =~# g:test#python#pytest#file_pattern
        if exists('g:test#python#runner')
            return g:test#python#runner ==# 'make'
        else
            return executable("make") && !empty(glob("Makefile"))
        endif
    endif
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#python#make#build_position(type, position)
    return test#python#pytest#build_position(a:type, a:position)
endfunction

" Returns processed args (if you need to do any processing)
function! test#python#make#build_args(args, color)
    let build_args = test#python#pytest#build_args(a:args, a:color)
    return ["test=" . join(build_args)]
endfunction

" Returns the executable of your test runner
function! test#python#make#executable()
    return "make unit"
endfunction

" From https://github.com/vim-test/vim-test/issues/147#issuecomment-667483332
" Try to infer the test suite, so that :TestSuite works without opening a test file
if exists('g:test#last_position')
    finish
endif

let s:patterns = [
            \ { 'dir': 'tests', 'pattern': 'test_*.py'},
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
