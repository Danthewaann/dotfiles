set nocompatible
filetype off

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

" Enable use of the mouse for all modes
if has('mouse')
  set mouse=a
endif

" Can set the command window height to 2 lines, to avoid many cases of having to
" press <Enter> to continue
set cmdheight=1

" Make sure at 5 lines are above/below the cursor
set scrolloff=8

" Update the highlight incrementally
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

" Search down into subfolders
" Provides tab-completion for all file-related tasks
" See ':h path' for more info
set path+=**

" Set the clipboard up to use the system clipboard to allow pasting from other programs
if system('uname -s') == "Darwin\n"
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files
set confirm

" Set the update time so vim refreshes quickly
set updatetime=50

" From https://stackoverflow.com/a/58042714
" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=50 ttyfast

" Disable line width so no long lines don't get broken up
set textwidth=0
set wrapmargin=0

" Make backspaces more powerful
set backspace=indent,eol,start

" Hide instead of closing buffers. It allows hiding buffer with unsaved
" modifications and preserve marks and undo history
set hidden

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if has("termguicolors")
    set termguicolors
endif

" Toggle highlight search
nnoremap <silent><Esc> :set hls!<cr>

" Move the current visual selection up or down a line at a time
" From https://vim.fandom.com/wiki/Moving_lines_up_or_down
vnoremap <silent>K :m '<-2<CR>gv=gv
vnoremap <silent>J :m '>+1<CR>gv=gv

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Center screen after moving through matches
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv
nnoremap # #zzzv

" Replace current word in current file
nnoremap <leader>rp :%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>

" Replace visual selection in current file
vnoremap <leader>rp "ky:%s/<C-R>=escape(@k, "/")<CR>/<C-R>=escape(@k, "/")<CR>/gI<Left><Left><Left>

" Use <C-P> and <C-N> to cycle through history in vim command mode
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" COLOUR THEME ===================================================================================================

" The slate colourscheme is available from vim 7.4 onwards
augroup my_colorschemes
  au!
  au Colorscheme slate hi Normal guibg=#1a1d21
                \ | hi StatusLine guifg=#ffffff guibg=#272731
                \ | hi StatusLineNC guifg=#666666 guibg=#272731
                \ | hi VertSplit guibg=NONE
augroup END

set background=dark
colorscheme slate 

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

" Close all buffers in the current window/tab
nnoremap <silent><C-W>q :tabclose<CR>

" Window navigation
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" Tab navigation
nnoremap <silent><C-W><C-H> :tabprevious<CR>
nnoremap <silent><C-W><C-L> :tabnext<CR>

" Open a new tab
nnoremap <silent><C-W>N :tabnew<CR>

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
