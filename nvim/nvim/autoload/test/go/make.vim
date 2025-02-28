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
        " Need to add another `$` to the `test` arg to escape the trailing `$`.
        let args = ["unit", "test=" . test . "$" . " path=" . path ]
    else
        let args = []
        let path = build_args[0]
        if path == "./..."
            let args = ["test"]
        else
            let args = ["unit", "path=" . path]
        endif
    endif
    return args
endfunction

" Returns the executable of your test runner
function! test#go#make#executable()
    return "make"
endfunction
