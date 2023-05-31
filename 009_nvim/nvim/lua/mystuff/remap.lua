vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
-- which is the default
vim.keymap.set("n", "Y", "y$")

-- Vertical navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "gg", "ggzz")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")

-- Jump list navigation
vim.keymap.set("n", "<C-i>", "<C-i>zz")
vim.keymap.set("n", "<C-o>", "<C-o>zz")

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("t", "<C-h>", "<C-\\><C-n>C-h>")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n>C-j>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n>C-k>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-l>")

-- Tab navigation
vim.keymap.set("n", "<C-w><C-h>", "<cmd> silent tabprevious<CR>")
vim.keymap.set("t", "<C-w><C-h>", "<C-\\><C-n> <cmd> silent tabprevious<CR>")
vim.keymap.set("n", "<C-w><C-l>", "<cmd> silent tabnext<CR>")
vim.keymap.set("t", "<C-w><C-l>", "<C-\\><C-n> <cmd> silent tabnext<CR>")

-- Close tab
vim.keymap.set("n", "<C-w>q", "<cmd> tabclose<CR>")
vim.keymap.set("t", "<C-w>q", "<C-\\><C-n> <cmd> silent tabclose<CR>")

-- Close all tabs except current one
vim.keymap.set("n", "<C-w>to", "<cmd> tabonly<CR>")
vim.keymap.set("t", "<C-w>to", "<C-\\><C-n> <cmd> silent tabonly<CR>")

-- Open a new tab
vim.keymap.set("n", "<C-w>N", "<cmd> tabnew<CR>")
vim.keymap.set("t", "<C-w>N", "<C-\\><C-n> <cmd> silent tabnew<CR>")

-- Go to tab by number
vim.keymap.set("n", "<C-w>1", "<cmd> tabn1<CR>")
vim.keymap.set("n", "<C-w>2", "<cmd> tabn2<CR>")
vim.keymap.set("n", "<C-w>3", "<cmd> tabn3<CR>")
vim.keymap.set("n", "<C-w>4", "<cmd> tabn4<CR>")
vim.keymap.set("n", "<C-w>5", "<cmd> tabn5<CR>")
vim.keymap.set("n", "<C-w>6", "<cmd> tabn6<CR>")
vim.keymap.set("n", "<C-w>7", "<cmd> tabn7<CR>")
vim.keymap.set("n", "<C-w>8", "<cmd> tabn8<CR>")
vim.keymap.set("n", "<C-w>9", "<cmd> tabn9<CR>")
vim.keymap.set("n", "<C-w>0", "<cmd> tablast<CR>")
vim.keymap.set("t", "<C-w>1", "<C-\\><C-n> <cmd> silent tabn1<CR>")
vim.keymap.set("t", "<C-w>2", "<C-\\><C-n> <cmd> silent tabn2<CR>")
vim.keymap.set("t", "<C-w>3", "<C-\\><C-n> <cmd> silent tabn3<CR>")
vim.keymap.set("t", "<C-w>4", "<C-\\><C-n> <cmd> silent tabn4<CR>")
vim.keymap.set("t", "<C-w>5", "<C-\\><C-n> <cmd> silent tabn5<CR>")
vim.keymap.set("t", "<C-w>6", "<C-\\><C-n> <cmd> silent tabn6<CR>")
vim.keymap.set("t", "<C-w>7", "<C-\\><C-n> <cmd> silent tabn7<CR>")
vim.keymap.set("t", "<C-w>8", "<C-\\><C-n> <cmd> silent tabn8<CR>")
vim.keymap.set("t", "<C-w>9", "<C-\\><C-n> <cmd> silent tabn9<CR>")
vim.keymap.set("t", "<C-w>0", "<C-\\><C-n> <cmd> silent tablast<CR>")

-- Enter normal-mode in nvim terminal
vim.keymap.set("t", "<C-w><C-x>", "<C-\\><C-n>")

-- Exit the current window
vim.keymap.set("n", "<C-q>", "<cmd> silent q<CR>")
vim.keymap.set("t", "<C-q>", "<C-\\><C-n> <cmd> silent q<CR>")

-- Treat Ctrl+C exactly like <Esc> in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Paste the clipboard contents in insert mode
vim.keymap.set("i", "<C-p>", "<C-r>+")

-- Search for current word in window and highlight it
vim.keymap.set("n", "<leader>f", "/\\V<C-r><c-w><CR>")
vim.keymap.set("v", "<leader>f", "\"ky/\\V<C-R>=@k<CR><CR>")

-- Center screen when moving through search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Open an nvim terminal
vim.keymap.set("n", "<C-t>s", "<cmd> silent 20 split new<CR><cmd> term<CR>")
vim.keymap.set("n", "<C-t>v", "<cmd> silent 100 vsplit new<CR><cmd> term<CR>")
vim.keymap.set("n", "<C-t>t", "<cmd> silent tabnew<CR><cmd> term<CR>")
vim.keymap.set("t", "<C-t>t", "<C-\\><C-o> <cmd> silent tabnew<CR><cmd> term<CR>")

-- Git commands 
vim.keymap.set("n", "<leader>gg",  "<cmd> silent Git<CR>")
vim.keymap.set("n", "<leader>gcc", "<cmd> silent Git commit<CR>")
vim.keymap.set("n", "<leader>gca", "<cmd> silent Git commit --amend<CR>")
vim.keymap.set("n", "<leader>gce", "<cmd> Git commit --amend --no-edit<CR>")

-- Replace current word in current file
vim.keymap.set("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Replace visual selection in current file
vim.keymap.set("v", "<leader>rp", [["ky:%s/<C-r>=@k<CR>/<C-r>=@k<CR>/gI<Left><Left><Left>]])

-- Show all commits
vim.keymap.set('n', '<leader>gv', "<cmd> silent GV<CR>")
