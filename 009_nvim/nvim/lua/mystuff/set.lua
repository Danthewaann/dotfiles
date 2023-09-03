-- Yank and paste to the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Display lines numbers
vim.opt.number = true

-- Display relative line numbers for easier vertical jumps
vim.opt.relativenumber = true

-- Use case insensitive search, except when using capital letters
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Indentation settings for using 4 spaces instead of tabs.
-- This configuration works for files that don't use tabs for indentation.
-- If the file uses indentation,'tabstop' needs to be set to `8`
-- and `expandtab` must be set to `false`.
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Show tabs and newline characters when `list` is enabled
vim.opt.listchars = "eol:¬,tab:▸."

-- Open splits naturally to the below and to the right
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Don't enable word wrap
vim.opt.wrap = false

-- Automatically resize windows after a window is closed
vim.opt.equalalways = true

-- No swap or backup files (can cause problems with coc.nvim)
vim.opt.swapfile = false
vim.opt.backup = false

-- Enable undos
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Highlight searches and update the highlight incrementally
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Enable 256 colours
vim.opt.termguicolors = true

-- Make sure 8 lines are above/below the cursor
vim.opt.scrolloff = 8

-- Enable the signcolumn for things like displaying git changes and markers
vim.opt.signcolumn = "yes"

-- Set updatetime to a low number for faster updates
vim.opt.updatetime = 50

-- Don't show mode information (normal, insert etc.) as I've included it in the statusline
vim.opt.showmode = false

-- Instead of failing a command because of unsaved changes, instead raise a
-- dialogue asking if you wish to save changed files
vim.opt.confirm = true
