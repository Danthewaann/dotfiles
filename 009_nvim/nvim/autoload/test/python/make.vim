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
    return ["unit", "test=" . join(build_args)]
endfunction

" Returns the executable of your test runner
function! test#python#make#executable()
    return "make"
endfunction
