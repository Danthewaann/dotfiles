-- Yank and paste to the system clipboard
vim.o.clipboard = "unnamedplus"

-- Display line numbers
vim.wo.number = true

-- Disable wrap
vim.o.wrap = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable break indent
vim.o.breakindent = true

-- Set completeo to have a better completion experience
vim.o.completeo = 'menuone,noselect'

-- Show tabs and newline characters when `list` is enabled
vim.o.listchars = "eol:¬,tab:▸."

-- Open splits naturally to the below and to the right
vim.o.splitbelow = true
vim.o.splitright = true

-- Automatically resize windows after a window is closed
vim.o.equalalways = true

-- Enable undos
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

-- Highlight searches and update the highlight incrementally
vim.o.hlsearch = true
vim.o.incsearch = true

-- Enable 256 colours
vim.o.termguicolors = true

-- Make sure 8 lines are above/below the cursor
vim.o.scrolloff = 8

-- Enable the signcolumn for things like displaying git changes and markers
vim.o.signcolumn = "yes"

-- Set updatetime to a low number for faster updates
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeo to have a better completion experience
vim.o.completeo = 'menuone,noselect'

-- Don't show mode information (normal, insert etc.) as I've included it in the statusline
vim.o.showmode = false

-- Instead of failing a command because of unsaved changes, instead raise a
-- dialogue asking if you wish to save changed files
vim.o.confirm = true

-- Don't show what I'm typing on the right hand side of the command line
vim.o.showcmd = false

-- Setup folds with treesitter and nvim-ufo
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Search down into subfolders
-- Provides tab-completion for all file-related tasks
vim.opt.path:append("**")
