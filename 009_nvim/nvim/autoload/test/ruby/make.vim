" Returns true if the given file belongs to your test runner
function! test#ruby#make#test_file(file)
    echom a:file
    if fnamemodify(a:file, ':t') =~# g:test#ruby#rspec#file_pattern
        echom "hi"
        if exists('g:test#ruby#runner')
            return g:test#ruby#runner ==# 'make'
        else
            return executable("make") && !empty(glob("Makefile"))
        endif
    endif
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#ruby#make#build_position(type, position)
    return test#ruby#rspec#build_position(a:type, a:position)
endfunction

" Returns processed args (if you need to do any processing)
function! test#ruby#make#build_args(args, color)
    let build_args = test#ruby#rspec#build_args(a:args, a:color)
    return ["TEST_PATTERN=" . join(build_args)]
endfunction

" Returns the executable of your test runner
function! test#ruby#make#executable()
    return "make test"
endfunction

" From https://github.com/vim-test/vim-test/issues/147#issuecomment-667483332
" Try to infer the test suite, so that :TestSuite works without opening a test file
if exists('g:test#last_position')
    finish
endif

let s:patterns = [
            \ { 'dir': 'spec', 'pattern': '*_spec.rb'},
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
