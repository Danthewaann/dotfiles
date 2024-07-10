" Returns true if the given file belongs to your test runner
function! test#ruby#make#test_file(file)
    if fnamemodify(a:file, ':t') =~# g:test#ruby#rspec#file_pattern
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
    if len(build_args) > 0
        return ["test", "TEST_PATTERN=" . join(build_args)]
    else
        return ["test"]
    endif
endfunction

" Returns the executable of your test runner
function! test#ruby#make#executable()
    return "make"
endfunction
