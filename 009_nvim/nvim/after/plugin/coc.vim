" Set config location to home
let g:coc_config_home = '~/'

" Set global coc extensions
let g:coc_global_extensions = [
            \'coc-eslint',
            \'coc-prettier',
            \'coc-sh',
            \'coc-go',
            \'coc-tsserver',
            \'coc-json',
            \'coc-pyright',
            \'coc-git',
            \'coc-css',
            \'coc-html',
            \'coc-htmlhint',
            \'coc-toml',
            \'coc-clangd',
            \'coc-rust-analyzer',
            \'coc-solargraph',
            \'coc-vimlsp',
            \'coc-word',
            \'coc-dictionary',
            \'coc-syntax',
            \'coc-sql',
            \'coc-yank',
            \'coc-markdownlint',
            \'coc-docker',
            \'coc-post',
            \'coc-db',
            \'coc-snippets',
            \'coc-highlight',
            \]

" Restart Coc
nnoremap <silent><leader>cr :CocRestart<CR><CR>

" Open pyrightconfig settings
command! PyrightConfig :e ~/pyrightconfig.json

" Disable transparent cursor
let g:coc_disable_transparent_cursor = 1

function! Save(error = v:null, result = v:null) abort
    if a:error == v:null
        execute "w"
    else
        echohl WarningMsg
        echo a:error
        echohl None
    endif
endfunction

function! Format(error = v:null, result = v:null, callback = "Save") abort
    if a:error == v:null
        call CocActionAsync('format', function(a:callback))
    else
        echohl WarningMsg
        echo a:error
        echohl None
    endif
endfunction

function! Sort(error = v:null, result = v:null, callback = "Save") abort
    if a:error == v:null
        call CocActionAsync('runCommand', 'editor.action.organizeImport', function(a:callback))
    else
        echohl WarningMsg
        echo a:error
        echohl None
    endif
endfunction

" Use `:S` to organize imports and save current buffer
command! -nargs=0 S :call Sort()

" Add `:W` command to format and save current buffer
command! -nargs=0 W :call Format()

" Use `:WW` to organize imports, format and save current buffer
command! -nargs=0 WW :call Sort(v:null, v:null, "Format")

" Use tab for trigger completion with characters ahead and navigate
"
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> <leader>cd :CocDiagnostics<CR>
nmap <silent> [d <Plug>(coc-diagnostic-prev)zz
nmap <silent> ]d <Plug>(coc-diagnostic-next)zz

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)zz
nmap <silent> gt :call CocAction('jumpDefinition', 'tabe')<CR>zz
nmap <silent> gs :call CocAction('jumpDefinition', 'split')<CR>zz
nmap <silent> gh :call CocAction('jumpDefinition', 'vsplit')<CR>zz
nmap <silent> gy <Plug>(coc-type-definition)zz
nmap <silent> gr <Plug>(coc-references)

" Applying code actions to the selected code block
"
" Example: `<leader>aap` for current paragraph
xmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-line)

" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor
augroup highlight_symbol
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Map function and class text objects
"
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

function! CocSearchForSelectionInWorkspace()
    execute 'CocList -I --input=' . expand("<cword>") . ' symbols'
endfunction

" Mappings for CocList
"
" Show all diagnostics
nnoremap <silent><nowait> <leader>ld  :<C-u>CocList diagnostics<CR>

" Manage extensions
nnoremap <silent><nowait> <leader>le  :<C-u>CocList extensions<CR>

" Show commands
nnoremap <silent><nowait> <leader>lc  :<C-u>CocList commands<CR>

" Resume latest coc list
nnoremap <silent><nowait> <leader>lr  :<C-u>CocListResume<CR>

" Find symbol of current document
nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<CR>

" Show workspace folders
nnoremap <silent><nowait> <leader>lf  :<C-u>CocList folders<CR>

" Search workspace jump locations
nnoremap <silent><nowait> <leader>ll  :<C-u>CocList location<CR>

" Show yank history
nnoremap <silent><nowait> <leader>ly  :<C-u>CocList -A --normal yank<CR>

" Search workspace symbols
nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<CR>

" Search for the current current word in workspace symbols
nnoremap <silent><nowait> <leader>S  :call CocSearchForSelectionInWorkspace()<CR>

function ToggleDiagnostics() abort
    let diagnostic_info = get(b:, 'coc_diagnostic_info', {})
    if diagnostic_info == {}
        echo "Toggling diagnostics on"
    else
        echo "Toggling diagnostics off"
    endif
    call CocActionAsync('diagnosticToggle')
endfunction

" Toggle diagnostics
nnoremap <silent><nowait> <leader>dt  :call ToggleDiagnostics()<CR>

" Refresh diagnostics
nnoremap <silent><nowait> <leader>dr  :echo "Refreshing diagnostics"<CR>:call CocActionAsync('diagnosticRefresh')<CR>

let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-H> :<C-U>TmuxNavigateLeft<cr>
nnoremap <silent> <expr> <C-J> coc#float#has_scroll() ? coc#float#scroll(1) : ":<C-U>TmuxNavigateDown" . "\<CR>"
nnoremap <silent> <expr> <C-K> coc#float#has_scroll() ? coc#float#scroll(0) : ":<C-U>TmuxNavigateUp" . "\<CR>" 
nnoremap <silent> <C-L> :<C-U>TmuxNavigateRight<cr>
nnoremap <silent> <C-\> :<C-U>TmuxNavigatePrevious<cr>
