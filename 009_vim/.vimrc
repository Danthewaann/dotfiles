set nocompatible              " required
filetype off                  " required

" Must define this before loading vimspector
let g:vimspector_enable_mappings = 'HUMAN'

let my_node_path = '~/.nvm/versions/node/v' . expand('$MY_NODE_VERSION') . '/bin/node'

" Only set this if node is available
if !empty(glob(my_node_path))
    let g:coc_node_path = my_node_path
else
    let g:coc_start_at_startup = 0
endif

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
            \]

set nobackup
set nowritebackup

call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'joshdick/onedark.vim'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-test/vim-test'
Plug 'tpope/vim-commentary'
Plug 'michaeljsmith/vim-indent-object'
Plug 'puremourning/vimspector'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'godlygeek/tabular'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'djoshea/vim-autoread'
Plug 'fatih/vim-go'
Plug 'moll/vim-bbye'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-obsession'
Plug 'sheerun/vim-polyglot'
Plug 'dcrblack/tslime.vim'
Plug 'kshenoy/vim-signature'
Plug 'pixelneo/vim-python-docstring'
Plug 'romainl/vim-cool'
Plug 'Konfekt/FastFold'
Plug 'tmhedberg/SimpylFold'
Plug 'tpope/vim-unimpaired'
Plug 'honza/vim-snippets'
Plug 'rhysd/conflict-marker.vim'
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

" Need to also install this for searching through files
" https://github.com/ggreer/the_silver_searcher
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Auto-completion for quotes, parens, brackets, etc
Plug 'Raimondi/delimitMate'

" Must be loaded last
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'

" NOTE: I had to disable this plugin due to this issue: https://github.com/ryanoasis/vim-devicons/issues/384
" Plug 'ryanoasis/vim-devicons'

Plug 'PhilRunninger/nerdtree-visual-selection'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

" GENERAL ===================================================================================================

" Enable syntax highlighting
if has('syntax')
  syntax on
endif

" Make sure we use UTF-8 encoding
set encoding=utf-8

" Use <Space> as leader key
let mapleader = " "

" Set number of commands to remember
set history=10000

" Open splits naturally to the below and to the right
set splitbelow
set splitright

" Display lines numbers
set number

" Display relative line numbers for easier vertical jumps
set relativenumber

" Enable use of the mouse for all modes
if has('mouse')
  set mouse=a
endif

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Indentation settings for using 4 spaces instead of tabs
" Do not change 'tabstop' from its default value of 8 with this setup
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" Make sure at 5 lines are above/below the cursor
set scrolloff=5

" Highlight searches and update the highlight incrementally
set hlsearch
set incsearch

" Stop certain movements from always going to the first character of a line
set nostartofline

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Set maximum amount of memory (in Kbyte) to use for pattern matching
set maxmempattern=2000000

" Better command-line completion
set wildmenu

" Set spell checking for markdown and gitcommit files
augroup spell_checking
    autocmd!
    autocmd FileType markdown,gitcommit setlocal spell spelllang=en_us,en_gb
augroup END

" Disable line wrapping, sign column and line numbers in the vim terminal (especially in terminal normal mode)
augroup vim_terminal_settings
  autocmd!
  autocmd TerminalWinOpen * setlocal nowrap nonumber norelativenumber signcolumn=no
augroup end

" Set the clipboard up to use the system clipboard to allow pasting from other programs
if system('uname -s') == "Darwin\n"
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

" Don't use a swapfile
set noswapfile

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files
set confirm

" Set the update time so vim refreshes quickly
set updatetime=50

" Enable the signs column for things like displaying git changes and markers
set signcolumn=yes

" From https://stackoverflow.com/a/58042714
" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=50 ttyfast

" Disable line width so no long lines don't get broken up
set textwidth=0
set wrapmargin=0

" Use indent for folds
set foldmethod=indent

" Don't enable folds when opening a file automatically
set nofoldenable

" Make backspaces more powerful
set backspace=indent,eol,start

" Number of colors
set t_Co=256

" Hide instead of closing buffers. It allows hiding buffer with unsaved
" modifications and preserve marks and undo history
set hidden

" Don't show mode information as it is included in the statusline
set noshowmode

" Set font (not sure if I need this)
set guifont=Hack_Nerd_Font_Mono:h16

" Highlight the current line when in insert mode
augroup highlight_cursorline
    autocmd!
    autocmd InsertEnter * set cursorline
    autocmd InsertLeave * set nocursorline
augroup END

" Jump to last position when reopening a file
augroup last_position
    autocmd!
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
    set termguicolors
endif

" Allow gnome terminal to send alt keys to vim in the
" format that vim expects
" From https://stackoverflow.com/a/10216459
" NOTE: Need to manually disable shortcuts in gnome terminal as well
" let c='a'
" while c <= 'z'
" exec "set <A-".c.">=\e".c
" exec "imap \e".c." <A-".c.">"
" let c = nr2char(1+char2nr(c))
" endw
" set timeout ttimeoutlen=50

" move the current line up of down a line
" From https://vim.fandom.com/wiki/Moving_lines_up_or_down
" nnoremap <A-j> :m .+1<CR>==
" nnoremap <A-k> :m .-2<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
" vnoremap <A-j> :m '>+1<CR>gv=gv
" vnoremap <A-k> :m '<-2<CR>gv=gv
vnoremap <silent><C-K> :m '<-2<CR>gv=gv
vnoremap <silent><C-J> :m '>+1<CR>gv=gv
inoremap <silent><C-K> <Esc>:m .+1<CR>==gi
inoremap <silent><C-J> <Esc>:m .-2<CR>==gi

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Paste the clipboard contents in insert mode
inoremap <C-P> <C-R>+

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

" Escape the provided input for a regex search
function! Escape(input) abort
    return escape(a:input,'/\[\]\.\(\)')
endfunction

" Search for current word in window and highlight it
nmap <silent><leader>f viw<leader>f

" Search for visual selection in current file
" yanks to the k register so we don't override the 0 register (or clipboard)
vmap <silent><leader>f "ky/\V<C-R>=@k<CR><CR>

" Center screen after moving through matches
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz

" Keep track of last replace operation
let g:last_replace_operation = ""

function! ReplaceCurrentWord()
    let current_word = expand("<cword>")
    call inputsave()
    let replace = Escape(input('Enter replacement: ', current_word))
    call inputrestore()
    let cmd = '%s/\V' . current_word . '/' . replace . '/g'
    execute cmd
    let g:last_replace_operation = cmd
endfunction

function! GetVisualSelection()
    " Why is this not a built-in Vim script function?!
    " From https://stackoverflow.com/a/6271254
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! ReplaceSelection()
    let selection = GetVisualSelection()
    call inputsave()
    let replace = input('Enter replacement: ', selection)
    call inputrestore()
    let cmd = '%s/\V' . selection . '/' . replace . '/g'
    execute cmd
    let g:last_replace_operation = cmd
endfunction

function! ReplaceLast()
    if g:last_replace_operation != ""
        execute g:last_replace_operation
    else
        echohl WarningMsg
        echo "No replacement set"
        echohl None
    endif
endfunction

" Replace current word in current file
nnoremap <silent><leader>rp :call ReplaceCurrentWord()<CR>

" Replace visual selection in current file
vnoremap <silent><leader>rp :call ReplaceSelection()<CR>

" Run last replace command if it is set
nnoremap <silent><leader>rl :call ReplaceLast()<CR>

" Exit the current window
nnoremap <silent><C-Q> :q<CR>

" Treat Ctrl+C exactly like <Escape>
imap <C-C> <Esc>

" Vim-powered terminal in a split window
map <silent><C-T>s :20 split new<CR>:term ++curwin<CR>
tmap <silent><C-T>s <C-W>:term<CR>

" Vim-powered terminal in a vertical split window
map <silent><C-T>v :100 vsplit new<CR>:term ++curwin<CR>
tmap <silent><C-T>v <C-W>:vert term<CR>

" Vim-powered terminal in new tab
map <silent><C-T>t :$tab term<CR>
tmap <silent><C-T>t <C-W>:tab term<CR>

" Enter normal-mode in vim terminal
tnoremap <C-X> <C-W>N

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
    call term_start(cmd, {'curwin': 1, 'term_name': name})
    au BufLeave <buffer> wincmd p
    nnoremap <buffer> <Enter> :q<CR>
    redraw
    echo "Press <Enter> to exit terminal (<Ctrl-C> first if command is still running)"
endfunction

" Commands to run make commands in a terminal
command! -nargs=* Make :call RunCmdInTerminal('make', "$tab", <f-args>)
command! -nargs=* SMake :call RunCmdInTerminal('make', "20 split", <f-args>)
command! -nargs=* VMake :call RunCmdInTerminal('make', "100 vsplit", <f-args>)

" Use a line cursor within insert mode and a block cursor everywhere else
"
" Reference chart of values:
"   Ps = 0  -> blinking block
"   Ps = 1  -> blinking block (default)
"   Ps = 2  -> steady block
"   Ps = 3  -> blinking underline
"   Ps = 4  -> steady underline
"   Ps = 5  -> blinking bar (xterm)
"   Ps = 6  -> steady bar (xterm)
" if exists('$TMUX')
"     let &t_SI .= "\<Esc>Ptmux;\<Esc>\<Esc>[6 q\<Esc>\\"
"     let &t_EI .= "\<Esc>Ptmux;\<Esc>\<Esc>[2 q\<Esc>\\"
" else
"     let &t_SI .= "\<Esc>[6 q"
"     let &t_EI .= "\<Esc>[2 q"
" endif

let &t_SI .= "\<Esc>[6 q"
let &t_EI .= "\<Esc>[2 q"

" From kitty
" Mouse support
set ttymouse=sgr
set balloonevalterm

" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"

" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"

" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"

" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"

" Cursor control
let &t_RC = "\e[?12$p"
let &t_SH = "\e[%d q"
let &t_RS = "\eP$q q\e\\"
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"
let &t_VS = "\e[?12l"

" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
execute "set <FocusGained>=\<Esc>[I"
execute "set <FocusLost>=\<Esc>[O"

" Window title
let &t_ST = "\e[22;2t"
let &t_RT = "\e[23;2t"

" Vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase
let &t_ut=''

" COLOUR THEMES ===================================================================================================

set background=dark
let g:airline_powerline_fonts = 1
let g:enable_bold_font = 1
let g:enable_italic_font = 1
let g:airline_theme = 'onedark'
let g:onedark_hide_endofbuffer = 1
colorscheme onedark

" NAVIGATION ===================================================================================================

" Vertical navigation
nnoremap <C-D> <C-D>zz
nnoremap <C-U> <C-U>zz
nnoremap gg ggzz
nnoremap G Gzz
nnoremap { {zz
nnoremap } }zz

" Jump list navigation
nnoremap <C-I> <C-I>zz
nnoremap <C-O> <C-O>zz

" Allow scrolling up and down in a popup (such as function docstring in Python)
"
" From https://github.com/neoclide/coc.nvim/issues/1405#issuecomment-570062098
function FindCursorPopUp()
    let radius = get(a:000, 0, 2)
    let srow = screenrow()
    let scol = screencol()
    " it's necessary to test entire rect, as some popup might be quite small
    for r in range(srow - radius, srow + radius)
        for c in range(scol - radius, scol + radius)
            let winid = popup_locate(r, c)
            if winid != 0
                return winid
            endif
        endfor
    endfor

    return 0
endfunction

function ScrollPopUp(down)
    let winid = FindCursorPopUp()
    if winid == 0
        return 0
    endif

    let pp = popup_getpos(winid)
    call popup_setoptions( winid,
                \ {'firstline' : pp.firstline + ( a:down ? 1 : -1 ) } )
    return 1
endfunction

let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-H> :<C-U>TmuxNavigateLeft<cr>
nnoremap <silent> <expr> <C-J> ScrollPopUp(1) ? '<ESC>' : ':<C-U>TmuxNavigateDown' . "\<CR>"
nnoremap <silent> <expr> <C-K> ScrollPopUp(0) ? '<ESC>' : ':<C-U>TmuxNavigateUp' . "\<CR>"
nnoremap <silent> <C-L> :<C-U>TmuxNavigateRight<cr>
nnoremap <silent> <C-\> :<C-U>TmuxNavigatePrevious<cr>

" Close the terminal window
tnoremap <C-Q> <C-D>

" Close all buffers in the current window/tab
nnoremap <silent><C-W>q :tabclose<CR>
tnoremap <silent><C-W>q <C-W>:tabclose<CR>

" Close all tabs except the current one
nnoremap <silent><C-W>to :tabonly<CR>
tnoremap <silent><C-W>to <C-W>:tabonly<CR>

" Window navigation
tnoremap <C-H> <C-W><C-H>
tnoremap <C-J> <C-W><C-J>
tnoremap <C-K> <C-W><C-K>
tnoremap <C-L> <C-W><C-L>

" Tab navigation
nnoremap <silent><C-W><C-H> :tabprevious<CR>
tnoremap <silent><C-W><C-H> <C-W>:tabprevious<CR>
nnoremap <silent><C-W><C-L> :tabnext<CR>
tnoremap <silent><C-W><C-L> <C-W>:tabnext<CR>

" Open a new tab
nnoremap <silent><C-W>N :tabnew<CR>
tnoremap <silent><C-W>N <C-W>:tabnew<CR>

" Go to tab by number
noremap  <silent><C-W>1 :tabn1<CR>
noremap  <silent><C-W>2 :tabn2<CR>
noremap  <silent><C-W>3 :tabn3<CR>
noremap  <silent><C-W>4 :tabn4<CR>
noremap  <silent><C-W>5 :tabn5<CR>
noremap  <silent><C-W>6 :tabn6<CR>
noremap  <silent><C-W>7 :tabn7<CR>
noremap  <silent><C-W>8 :tabn8<CR>
noremap  <silent><C-W>9 :tabn9<CR>
noremap  <silent><C-W>0 :tablast<cr>
tnoremap <silent><C-W>1 <C-W>:tabn1<CR>
tnoremap <silent><C-W>2 <C-W>:tabn2<CR>
tnoremap <silent><C-W>3 <C-W>:tabn3<CR>
tnoremap <silent><C-W>4 <C-W>:tabn4<CR>
tnoremap <silent><C-W>5 <C-W>:tabn5<CR>
tnoremap <silent><C-W>6 <C-W>:tabn6<CR>
tnoremap <silent><C-W>7 <C-W>:tabn7<CR>
tnoremap <silent><C-W>8 <C-W>:tabn8<CR>
tnoremap <silent><C-W>9 <C-W>:tabn9<CR>
tnoremap <silent><C-W>0 <C-W>:tablast<cr>

" NERDTREE ===================================================================================================

" Set the NERDTree statusline
let NERDTreeStatusline = "NERDTree"

" Open directories and files with tab
let NERDTreeMapCustomOpen = "<Tab>"

" Remove bookmarks and help text from NERDTree
let g:NERDTreeMinimalUI = 1

" Unmap <C-J> so we can use <C-J> for navigation
let NERDTreeMapJumpNextSibling = ""

" Set NERDTree window size
let g:NERDTreeWinSize = 35

" Open or refresh NERDTree
function! OpenOrRefreshNERDTree() abort
    let bnr = bufwinnr('NERD_tree_*')
    if bnr > 0
        execute 'silent NERDTreeRefreshRoot'
    else
        execute 'NERDTree'
    endif
endfunction

nnoremap <silent> <leader>nn :call OpenOrRefreshNERDTree()<CR>

" Close NERDTree
nnoremap <silent> <leader>nc :NERDTreeClose<CR>

" Open NERDTree with buffer shown inside it
nnoremap <silent> <leader>nf :NERDTreeFind<CR>

" Ignore files in NERDTree
let NERDTreeIgnore = ['\.pyc$', '\~$']

" Show hidden files
let NERDTreeShowHidden = 1

" Center the NERDTree buffer when entering it
"
" From https://vi.stackexchange.com/questions/20619/nerdtree-maximize-on-enter
augroup center_nerd_tree
    autocmd!
    autocmd BufEnter NERD_tree_* normal zz
augroup END

" Start NERDTree when Vim starts with a directory argument
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
"     \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" COC ===================================================================================================

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

" Do default action for next item
nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>

" Do default action for previous item
nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>

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

" CTRL-P ===================================================================================================

let g:ctrlp_reuse_window = 'NERD'

" From https://elliotekj.com/posts/2016/11/22/setup-ctrlp-to-use-ripgrep-in-vim/
if executable("rg")
    set grepprg=rg\ --vimgrep\ --color=never
    let g:ctrlp_user_command = expand('$FZF_DEFAULT_COMMAND')
    let g:ctrlp_use_caching = 0
endif

let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:50'

" Ignore files matching these patterns when expanding wildcards
set wildignore+=*/.git/*,*.venv/*,*node_modules/*,*/tmp/*,*.swp

" VIM-TEST ===================================================================================================

let test#strategy = "vimterminal"
let test#vim#term_position = '$tab'
let test#custom_runners = {"python": ["make"]}
let test#python#runner = 'make'
let test#python#pytest#options = '-vv'

function! SetVimTestTermPosition() abort
    echo "1. Tab\n2. Horizontal Split\n3. Vertical Split"
    call inputsave()
    let num = Escape(input('Enter position num: '))
    call inputrestore()
    redraw
    if num == 1
        echo "Setting to tab"
        let g:test#vim#term_position = '$tab'
    elseif num == 2
        echo "Setting to horizontal split"
        let g:test#vim#term_position = 'botright 20'
    elseif num == 3
        echo "Setting to vertical split"
        let g:test#vim#term_position = '100 vsplit'
    else
        echohl WarningMsg
        echo "Num not valid"
        echohl None
    endif
endfunction

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
        call vimspector#LaunchWithSettings({'configuration': 'remote-launch', 'args': args})
    else
        call vimspector#LaunchWithSettings({'configuration': lang . ' - debug test', 'args': args})
    endif
endfunction

nnoremap <silent> <leader>tp :call SetVimTestTermPosition()<CR>
nnoremap <silent> <leader>dn :call MyDebugNearest()<CR>
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tc :TestClass<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>zz

" COC-GIT ========================================================================================================

" Navigate chunks of current buffer
nmap [c <Plug>(coc-git-prevchunk)zz
nmap ]c <Plug>(coc-git-nextchunk)zz

" Navigate conflicts of current buffer
nmap [h <Plug>(coc-git-prevconflict)zz
nmap ]h <Plug>(coc-git-nextconflict)zz

" Resolve conflict at current chunk
nmap <leader>gkc <Plug>(coc-git-keepcurrent)
nmap <leader>gki <Plug>(coc-git-keepincoming)
nmap <leader>gkb <Plug>(coc-git-keepboth)

function! CocGitRefreshGitStatus(error = v:null, result = v:null) abort
    let win_id = win_getid()
    call RefreshGitStatus()
    call win_gotoid(win_id)
endfunction

" Git push binds
nmap <silent><leader>gpp :call CocActionAsync('runCommand', 'git.push', function('CocGitRefreshGitStatus'))<CR>
nmap <silent><leader>gfp :call CocActionAsync('runCommand', 'git.push', '--force', function('CocGitRefreshGitStatus'))<CR>

" Show chunks in current buffer
nmap <leader>gch :CocList gchunks<CR>

" Open current line in browser
nmap <leader>go :call CocAction('runCommand', 'git.browserOpen')<CR>

" Fold unchanged lines in current buffer
nmap <silent><leader>gfu :call CocAction('runCommand', 'git.foldUnchanged')<CR>

" Show diff of staged changes in current buffer
nmap <silent><leader>gd :call CocAction('runCommand', 'git.diffCached')<CR>

" Stage chunk at current position
nmap <silent><leader>gs :echo "Staging chunk..."<CR>:silent call CocActionAsync('runCommand', 'git.chunkStage', function('CocGitRefreshGitStatus'))<CR>

" Unstage chunk at current position
nmap <silent><leader>gu :echo "Unstaging chunk..."<CR>:silent call CocActionAsync('runCommand', 'git.chunkUnstage', function('CocGitRefreshGitStatus'))<CR>

" Undo chunk at current position
nmap cu :silent call CocActionAsync('runCommand', 'git.chunkUndo', function('CocGitRefreshGitStatus'))<CR>

" Show chunk diff at current position
nmap cp <Plug>(coc-git-chunkinfo)

" Create text object for git chunks
omap ic <Plug>(coc-git-chunk-inner)
xmap ic <Plug>(coc-git-chunk-inner)
omap ac <Plug>(coc-git-chunk-outer)
xmap ac <Plug>(coc-git-chunk-outer)

" Hide git blame virtual text by default
let g:coc_git_hide_blame_virtual_text = 1

function! ToggleGitBlameVirtualText() abort
    let current = get(g:, 'coc_git_hide_blame_virtual_text', 0)
    if current == 0
        echo "Toggling git blame off"
    else
        echo "Toggling git blame on"
    endif
    let g:coc_git_hide_blame_virtual_text = !current
endfunction

" Toggle git blame virtual text
nnoremap <silent><leader>gb :call ToggleGitBlameVirtualText()<CR>

" COC-POST =======================================================================================================

function Post() abort
    if &filetype != 'post'
        echohl WarningMsg
        echo "Can only run :Post in a .post file!"
        echohl None
        return
    endif

    let changed_post_file = 0
    let post_buf = win_getid()

    " If this post file requires an API_KEY, make sure to set it
    let api_key_line = search('@API_KEY@')
    if api_key_line != 0
        let coc_post_api_key = trim(system("cat ~/.coc-post-api-key"))
        if v:shell_error || empty(coc_post_api_key)
            echohl WarningMsg
            echo "This post file requires an API_KEY"
            echohl None
            return
        endif
        execute api_key_line . ' s/@API_KEY@/' . coc_post_api_key . '/g'
        execute 'w'
        let changed_post_file = 1
    endif

    " Run the post file
    execute 'CocCommand post.do'

    " Make sure the post output window is visible before proceeding
    let timeout = 10
    let cur_buf = win_getid()
    while timeout > 0 && cur_buf == post_buf
        sleep 100ms
        let timeout = timeout - 1
        let cur_buf = win_getid()
    endwhile

    " Make sure the request body has been displayed before proceeding
    let timeout = 10
    while timeout > 0 && search("Body") == 0
        sleep 1000ms
        let timeout = timeout - 1
    endwhile

    " If there is an apiKey in the body, use it for future requests
    let api_key = search("apiKey")
    if api_key != 0
        let line = trim(split(getline(api_key), ":")[1])
        let line = substitute(line, '"', '', 'g')
        let line = substitute(line, ',', '', 'g')
        call system("echo " . line . " > ~/.coc-post-api-key")
    endif

    if changed_post_file == 1
        " Go back to the post file to undo our changes
        call win_gotoid(post_buf)
        execute 'u'
        execute 'w'
    endif
endfunction

" Run current post file
command! -nargs=0 Post call Post()

" Show all post files
nnoremap <silent><leader>cp :CocList post<CR>

" VIM-FUGITIVE ===================================================================================================

nnoremap <silent><leader>gg :call OpenOrRefreshGitStatus()<CR>
nnoremap <silent><leader>gcc :G commit<CR>
nnoremap <silent><leader>gce :G commit --amend --no-edit<CR>
nnoremap <silent><leader>gca :G commit --amend<CR>

function! RefreshGitStatus() abort
    for l:winnr in range(1, winnr('$'))
        if getwinvar(l:winnr, '&filetype') == "fugitive"
            execute 'Git'
            return v:true
        endif
    endfor
    return v:false
endfunction

function! OpenOrRefreshGitStatus() abort
    let git_open = RefreshGitStatus()
    if ! git_open
        Git
        resize-15
    endif
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

" VIMSPECTOR =====================================================================================================

" Open vimspector settings
command! VimspectorConfig :e ~/.vimspector.json

let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-node-debug2', 'delve' ]
let g:vimspector_bottombar_height = 25

" For custom UI stuff below
" keep track of when we moved the terminal so we
" don't keep moving it when restarting a vimspector session
let g:moved_terminal = 0

" For normal mode - the word under the cursor
nmap <leader>vi <Plug>VimspectorBalloonEval

" For visual mode, the visually selected text
xmap <leader>vi <Plug>VimspectorBalloonEval

nmap <leader><F11> <Plug>VimspectorUpFrame
nmap <leader><F12> <Plug>VimspectorDownFrame
nmap <leader>vb <Plug>VimspectorBreakpoints
nmap <leader>vd <Plug>VimspectorDisassemble

nnoremap <leader>vc <Plug>VimspectorContinue
nnoremap <leader>vr <Plug>VimspectorRestart

function! ResetVimpspector() abort
    execute 'VimspectorReset'
    let g:moved_terminal = 0
endfunction

nnoremap <silent><leader>vq :call ResetVimpspector()<CR>

let g:vimspector_sign_priority = {
            \    'vimspectorBP':             999,
            \    'vimspectorBPCond':         2,
            \    'vimspectorBPLog':          2,
            \    'vimspectorBPDisabled':     1,
            \    'vimspectorPC':             999,
            \    'vimspectorPCBP':           1001,
            \    'vimspectorCurrentThread':  1000,
            \    'vimspectorCurrentFrame':   1000,
            \ }

" Custom stuff for adding breakpoint() statements
"
" Partially from https://gist.github.com/berinhard/523420
func! s:GetLineContentAndWhitespace(line_num)
    let cur_line_content = getline(a:line_num)
    let cur_line_whitespace = strlen(matchstr(cur_line_content, '^\s*'))
    return {'content': cur_line_content, 'whitespace': cur_line_whitespace}
endf

func! s:SetBreakpoint()
    let cur_line_num = line('.')
    let cur_line = s:GetLineContentAndWhitespace(cur_line_num)

    " Check the next line first to see if it is indented more than the current line
    " if it is, use the indentation level of that line
    " otherwise go through all previous lines to get the correct indentation level
    let next_line = s:GetLineContentAndWhitespace(cur_line_num+1)
    if strlen(cur_line['whitespace']) > 0 && next_line['whitespace'] > cur_line['whitespace']
        let cur_line['whitespace'] = next_line['whitespace']
    else
        while cur_line['whitespace'] == 0
            if cur_line_num == 0
                break
            endif
            let cur_line_num = cur_line_num-1
            let cur_line = s:GetLineContentAndWhitespace(cur_line_num)
        endwhile

        " Check if the next line is indented more than the current line
        " if it is, use the indentation level of that line
        let next_line = s:GetLineContentAndWhitespace(cur_line_num+1)
        if strlen(cur_line['whitespace']) > 0 && next_line['whitespace'] > cur_line['whitespace']
            let cur_line['whitespace'] = next_line['whitespace']
        endif
    endif
    cal append('.', repeat(' ', cur_line['whitespace']) . 'breakpoint()')
endf

func! s:RemoveBreakpoint()
    exe 'silent! g/^\s*breakpoint()/d'
endf

func! s:ToggleBreakpoint()
    if getline('.')=~#'^\s*breakpoint()' | cal s:RemoveBreakpoint() | el | cal s:SetBreakpoint() | en
endf

nnoremap <silent> gb :call <SID>ToggleBreakpoint()<CR>

" From https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
"
" Setup a way to keep track of breakpoint() calls in Python code
function! GetAllBreakpoints()
    return system(join([&grepprg] + [' breakpoint\(\) -g "*.py" ./'], ' '))
endfunction

function! DeleteAllBreakpoints()
    let breakpoints = GetAllBreakpoints()
    let list = split(breakpoints, '\n')
    let files = []
    for item in list
        let file = split(item, ':')[0]
        if index(files, file) < 0
            call add(files, file)
            call system('sed -i -e /breakpoint\(\)/d ' . file)
        endif
    endfor
    if !empty(files)
        lgetexpr BreakpointsLocationList()
    endif
endfunction

command! -nargs=0 DeleteAllBreakpoints call DeleteAllBreakpoints()

function! BreakpointsLocationList()
    let breakpoints = GetAllBreakpoints()
    if empty(breakpoints)
        echohl WarningMsg
        echo "No breakpoint()s found"
        echohl None
    endif
    return breakpoints
endfunction

command! -nargs=0 Breakpoints lgetexpr BreakpointsLocationList() | call setloclist(0, [], 'a', {'title': 'PythonBreakpoints'})

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

function! s:CustomiseUI()
    let wins = g:vimspector_session_windows

    " Enable keyboard-hover for vars and watches
    call win_gotoid( g:vimspector_session_windows.variables )
    nmap <silent><buffer> <localleader>o <Plug>VimspectorBalloonEval
    nmap <silent><buffer> <Tab> <Enter>

    call win_gotoid( g:vimspector_session_windows.watches )
    nmap <silent><buffer> <localleader>o <Plug>VimspectorBalloonEval

    call win_gotoid( g:vimspector_session_windows.code )
    nmap <silent><buffer> <localleader>o <Plug>VimspectorBalloonEval

    let console_win = g:vimspector_session_windows.output
    call win_gotoid( console_win )
    inoremap <silent><buffer> <C-J> <C-W>j
    inoremap <silent><buffer> <C-K> <C-W>k
    inoremap <silent><buffer> <C-L> <C-W>l
    inoremap <silent><buffer> <C-H> <C-W>h
    inoremap <silent><buffer> <F5> <C-O>:call vimspector#Continue()<CR>
    inoremap <silent><buffer> <F10> <C-O>:call vimspector#StepOver()<CR>
    inoremap <silent><buffer> <F11> <C-O>:call vimspector#StepInto()<CR>
    inoremap <silent><buffer> <F12> <C-O>:call vimspector#StepOut()<CR>
    setlocal scrolloff=0
    setlocal modifiable
    resize-10
endfunction

function s:SetUpTerminal()
    if !has_key( g:vimspector_session_windows, 'terminal' )
        " There's a neovim bug which means that this doesn't work in neovim
        return
    endif
    let terminal_win = g:vimspector_session_windows.terminal

    " Add binds for easier navigation
    call win_gotoid( terminal_win )
    tnoremap <silent><buffer> <C-J> <C-W><C-J>
    tnoremap <silent><buffer> <C-K> <C-W><C-K>
    tnoremap <silent><buffer> <C-L> <C-W><C-L>
    tnoremap <silent><buffer> <C-H> <C-W><C-H>

    " Swap terminal position with console position
    " only works when I have a vertical tmux pane open
    " if g:moved_terminal != 1
    "     resize-5
    "     execute 'wincmd x'
    "     let g:moved_terminal = 1
    " endif
endfunction

let s:mapped = {}

function! s:OnJumpToFrame() abort
    let buf_nr = bufnr()
    let file_extension = expand('%:e')
    " Set filetype to python for now to get syntax highlighting
    " when doing remote debugging via a docker container
    if file_extension == "py"
        setlocal filetype=python
    endif

    if has_key(s:mapped, string(buf_nr))
        return
    endif

    nmap <silent><buffer> o <Plug>VimspectorBalloonEval

    let s:mapped[string(buf_nr)] = {'modifiable': &modifiable}
endfunction

function! s:OnDebugEnd() abort
    let original_buf = bufnr()
    let hidden = &hidden
    augroup VimspectorSwapExists
        au!
        autocmd SwapExists * let v:swapchoice='o'
    augroup END

    try
        set hidden
        for bufnr in keys(s:mapped)
            try
                execute 'buffer' bufnr
                silent! nunmap <buffer> o

                let &l:modifiable = s:mapped[ bufnr ][ 'modifiable' ]
            endtry
        endfor
    finally
        execute 'noautocmd buffer' original_buf
        let &hidden = hidden
    endtry

    au! VimspectorSwapExists

    let s:mapped = {}
endfunction

augroup MyVimspectorCustomisation
    autocmd!
    autocmd User VimspectorUICreated call s:CustomiseUI()
    autocmd User VimspectorTerminalOpened call s:SetUpTerminal()
    autocmd User VimspectorJumpedToFrame call s:OnJumpToFrame()
    autocmd User VimspectorDebugEnded ++nested call s:OnDebugEnd()
augroup END

" Allow for command history in VimspectorPrompt
"
" from https://github.com/puremourning/vimspector/issues/52#issuecomment-699027787
augroup vimspector_command_history
    autocmd!
    autocmd FileType VimspectorPrompt call InitializeVimspectorCommandHistory()
augroup end

function! InitializeVimspectorCommandHistory()
    if !exists('b:vimspector_command_history')
        inoremap <silent> <buffer> <CR> <C-o>:call VimspectorCommandHistoryAdd()<CR>
        inoremap <silent> <buffer> <Up> <C-o>:call VimspectorCommandHistoryUp()<CR>
        inoremap <silent> <buffer> <Down> <C-o>:call VimspectorCommandHistoryDown()<CR>
        inoremap <silent> <buffer> <C-c> <C-c>dd:startinsert<CR>
        let b:vimspector_command_history = []
        let b:vimspector_command_history_pos = 0
    endif
endfunction

function! VimspectorCommandHistoryAdd()
    let line = trim(getline('.'))
    if line != '>'
        call add(b:vimspector_command_history, line)
        let b:vimspector_command_history_pos = len(b:vimspector_command_history)
    endif
    call feedkeys("\<CR>i", 'tn')
endfunction

function! VimspectorCommandHistoryUp()
    if len(b:vimspector_command_history) == 0 || b:vimspector_command_history_pos == 0
        return
    endif
    call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
    call feedkeys("\<C-o>A", 'tn')
    let b:vimspector_command_history_pos = b:vimspector_command_history_pos - 1
endfunction

function! VimspectorCommandHistoryDown()
    if b:vimspector_command_history_pos == len(b:vimspector_command_history)
        return
    endif
    call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
    call feedkeys("\<C-o>A", 'tn')
    let b:vimspector_command_history_pos = b:vimspector_command_history_pos + 1
endfunction

" VIM-MARKDOWN ===================================================================================================

let g:vim_markdown_folding_disabled = 1

" VIM-DADBOD ======================================================================================================

" Use nerd fonts for the UI
let g:db_ui_use_nerd_fonts = 1

" Open DB connections window
nnoremap <silent><leader>db :DBUI<CR>

" Unmap these as I use <C-J/K> for navigating windows
autocmd FileType dbui unmap <buffer> <C-J>
autocmd FileType dbui unmap <buffer> <C-K>

" Use tab for opening drawers
autocmd FileType dbui map <Tab> <Plug>(DBUI_SelectLine)

" VIM-BBYE =======================================================================================================

" Close the current buffer without closing the window
nnoremap <silent><leader>bd :Bdelete<CR>

" Delete all buffers except the current one
"
" From https://stackoverflow.com/questions/4545275/vim-close-all-buffers-but-this-one
command! BufOnly silent! execute "%bd|e#|bd#"
nnoremap <silent><leader>bo :BufOnly<CR>

" Delete all(saved) but visible buffers
"
" From https://vi.stackexchange.com/a/27106
function! Delete_buffers() abort
    " All visible buffers in all tabs
    let buflist = []
    for i in range(tabpagenr('$'))
        call extend(buflist, tabpagebuflist(i + 1))
    endfor

    " All existing buffers
    for bnr in range(1, bufnr("$"))
        if index(buflist, bnr) == -1 && buflisted(bnr)
            execute 'bdelete ' . bnr
        endif
    endfor
endfunction

" Kill-all but visible buffers
nnoremap <silent> <leader>bda :call Delete_buffers()<CR>:echo "Non-windowed buffers are deleted"<CR>

" VIM-FZF ========================================================================================================

" Override Rg command to also search hidden files
command! -bang -nargs=* Rg call
            \ fzf#vim#grep("rg --hidden --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>),
            \ 1, fzf#vim#with_preview(), <bang>0)

" NOTE: Tmux seems to insert a `I` character when I run any of the
" below fzf commands
" Issue: https://github.com/junegunn/fzf.vim/issues/1356
"
" Open up a fzf files window
nnoremap <silent><C-F> :Files!<CR>

" Search in all project files
nnoremap <leader>F :Rg!<Space>

" Search for visual selection in project files
vnoremap <silent><leader>F "ky:Rg! <C-R>=Escape(@k)<CR><CR>

" Show all buffers
nnoremap <silent><leader>bb :Buffers!<CR>

" Show changed files
nnoremap <silent><leader>gfs :GFiles!?<CR>

" Show commits
nnoremap <leader>gl :Commits!<CR>

" Use colours from the current colour scheme
let g:fzf_colors = {
            \ 'fg':         ['fg', 'Normal'],
            \ 'bg':         ['bg', 'Normal'],
            \ 'preview-bg': ['bg', 'NormalFloat'],
            \ 'hl':         ['fg', 'Comment'],
            \ 'fg+':        ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':        ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':        ['fg', 'Statement'],
            \ 'info':       ['fg', 'PreProc'],
            \ 'border':     ['fg', 'Ignore'],
            \ 'prompt':     ['fg', 'Conditional'],
            \ 'pointer':    ['fg', 'Exception'],
            \ 'marker':     ['fg', 'Keyword'],
            \ 'spinner':    ['fg', 'Label'],
            \ 'header':     ['fg', 'Comment'] }

" VIM-GO ==========================================================================================================

" Show godoc output in a popup window
let g:go_doc_popup_window = 1

" TSLIME ==========================================================================================================

let g:tslime_always_current_session = 1
let g:tslime_always_current_window = 1
let g:tslime_autoset_pane = 1
let g:tslime_pre_command = "C-c"

" VIM-SIGNATURE ===================================================================================================

" List all global marks
nnoremap <leader>m :SignatureListGlobalMarks<CR>

" VIM-PYTHON-DOCSTRING ============================================================================================

" Generate docstring for def or class on current line
nnoremap <silent> <leader>ds :Docstring<CR>

" VIM-AIRLINE =====================================================================================================

" Enable coc git in tabline
let g:airline#extensions#hunks#coc_git = 1

" Disable vim-fugitive branch name integration
let g:airline#extensions#branch#enabled = 0

" Don't format the branch name (leave it as it is)
let g:airline#extensions#branch#format = 0

" Don't truncate long branch names (set the branch name limit to 999)
let g:airline#extensions#branch#displayed_head_limit = 999

" From https://www.reddit.com/r/vim/comments/crs61u/best_airline_settings/
" Enable the tabline
let g:airline#extensions#tabline#enabled = 1

" Remove 'X' at the end of the tabline
let g:airline#extensions#tabline#show_close_button = 0

" Can put text here like BUFFERS to denote buffers (I clear it so nothing is shown)
let g:airline#extensions#tabline#tabs_label = ''

" Can put text here like TABS to denote tabs (I clear it so nothing is shown)
let g:airline#extensions#tabline#buffers_label = ''

" Don't show tab numbers on the right
let g:airline#extensions#tabline#show_tab_count = 0

" Don't show buffers in the tabline
let g:airline#extensions#tabline#show_buffers = 0

" Don't show open splits per tab (on the right side on the tabline)
let g:airline#extensions#tabline#show_splits = 0

" Disable tab numbers
let g:airline#extensions#tabline#show_tab_nr = 2

" Show number for each tab
let g:airline#extensions#tabline#tab_nr_type = 1

" Minimum of 1 tab needed to display the tabline
let g:airline#extensions#tabline#tab_min_count = 1

" Disables the weird orange arrow on the tabline
let g:airline#extensions#tabline#show_tab_type = 0

" Use a custom tabtitle formatter
let g:airline#extensions#tabline#tabtitle_formatter = 'MyTabTitleFormatter'

function MyTabTitleFormatter(n)
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let bufnr = buflist[winnr - 1]
    let winid = win_getid(winnr, a:n)
    let title = bufname(bufnr)

    if empty(title)
        if getqflist({'qfbufnr' : 0}).qfbufnr == bufnr
            let title = '[Quickfix List]'
        elseif winid && getloclist(winid, {'qfbufnr' : 0}).qfbufnr == bufnr
            let title = '[Location List]'
        else
            let title = '[No Name]'
        endif
    elseif title =~ '^make .*'
        let title = title
    else
        let parent = fnamemodify(title, ':h:t')
        let file = fnamemodify(title, ':t')
        let title = join([parent, file], "/")
    endif

    return title
endfunction

" VIM-CONFLICT-MARKER =============================================================================================

" Disable matchit as I don't use it
let g:conflict_marker_enable_matchit = 0

" Disable the default highlight group
let g:conflict_marker_highlight_group = ''

" Include text after begin and end markers
let g:conflict_marker_begin = '^<<<<<<< .*$'
let g:conflict_marker_end   = '^>>>>>>> .*$'

" CHEATSHEET ======================================================================================================
"
" ga -> get encoding of character at cursor
" gq<CR> -> autoformat current paragraph
" gqq -> autoformat current line
" gf -> open path at cursor or selection
" gi -> go back to the last place you were in insert mode
" gu -> lowercase text object
" gU -> uppercase text object
" ~ -> change case of current character
" J -> join lines
" g& -> run last substitution on the whole file
" g_ -> move to last blank character in the line (like $)
" _ -> move to the first blank character in the line (like 0)
"
" ap, ip -> operate on continuous lines
"
" gcc -> comment out a line
" gcap -> comment of the current paragraph
" gcgc -> uncomment adjacent lines
"
" Edit multiple lines (add double quote to end of each line) - V -> :s/$/” -> <CR>
"
" Replace a word in a file selectively
" /word -> cgn -> replacement -> <CR> -> . (to repeat)
"
" :Obess to start recording you vim session to a Session.vim file in current directory
"
" To surround a visual selection in quotes highlight your selection and then press S<quote>

