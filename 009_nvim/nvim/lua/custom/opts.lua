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
pcall(function()
  vim.o.completeo = "menuone,noselect"
end)
pcall(function()
  vim.o.completeopt = "menuone,noselect"
end)

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

-- Allow for maximum scroll back in the neovim terminal emulator
vim.o.scrollback = 100000

-- Enable the signcolumn for things like displaying git changes and markers
vim.o.signcolumn = "yes"

-- Set updatetime to a low number for faster updates
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Don't show mode information (normal, insert etc.) as I've included it in the statusline
vim.o.showmode = false

-- Instead of failing a command because of unsaved changes, instead raise a
-- dialogue asking if you wish to save changed files
vim.o.confirm = true

-- Don't show what I'm typing on the right hand side of the command line
vim.o.showcmd = false

-- Don't show search count while searching (let lualine manage it)
-- Also don't show ins-completion-menu messages
vim.opt.shortmess:append("Sc")

-- Setup folds with treesitter and nvim-ufo
vim.o.foldcolumn = "0"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- Search down into subfolders
-- Provides tab-completion for all file-related tasks
vim.opt.path:append("**")

-- Setup what gets saved in the session file
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"

-- Don't save current directory and cursor position when running :mkview
-- From: https://github.com/kevinhwang91/nvim-ufo/issues/115#issuecomment-1694253333
vim.opt.viewoptions:remove("curdir")
vim.opt.viewoptions:remove("cursor")

-- Use ripgrep for the :grep command
vim.o.grepprg = "rg --vimgrep --color=never"

-- Filename:line:column:message
vim.o.grepformat = "%f:%l:%c:%m"

-- Disable swap files as they can be annoying
vim.o.swapfile = false

-- Recognize numbered lists when formatting text with `gq`
-- Also don't auto insert comments
vim.cmd("autocmd BufEnter * set formatoptions=jqlnt")
vim.cmd("autocmd BufEnter * setlocal formatoptions=jqlnt")

-- Go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

-- Make the jumplist not confusing sometimes
vim.o.jumpoptions = "stack"

-- Command-line completion mode
vim.o.wildmode = "longest:full,full"
