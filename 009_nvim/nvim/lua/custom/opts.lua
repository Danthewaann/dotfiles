-- Yank and paste to the system clipboard
vim.o.clipboard = "unnamedplus"

-- Show where the cursor is
vim.o.cursorline = true

-- Display line numbers
vim.wo.number = true

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Disable wrap
vim.o.wrap = false

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable break indent
vim.o.breakindent = true

-- Set completeo to have a better completion experience
if vim.fn.has("nvim-0.10") == 1 then
  vim.o.completeopt = "menu,menuone,noinsert"
else
  vim.o.completeo = "menu,menuone,noinsert"
end

-- Show special characters when `list` is enabled
vim.opt.listchars = { tab = "▸.", trail = "·", nbsp = "␣", eol = "¬" }

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
vim.o.scrolloff = 16

-- Make sure 8 columns are left/right of the cursor
vim.o.sidescrolloff = 16

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
-- Also don't show `scanning tags` messages in ins-completion
vim.opt.shortmess:append("ScsC")

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

-- Don't save current directory when running :mkview
-- From: https://github.com/kevinhwang91/nvim-ufo/issues/115#issuecomment-1694253333
vim.opt.viewoptions:remove("curdir")

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
