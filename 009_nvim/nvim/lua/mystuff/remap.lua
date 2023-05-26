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
vim.keymap.set("t", "<C-h>", "<C-\\><C-o>C-h>")
vim.keymap.set("t", "<C-j>", "<C-\\><C-o>C-j>")
vim.keymap.set("t", "<C-k>", "<C-\\><C-o>C-k>")
vim.keymap.set("t", "<C-l>", "<C-\\><C-o><C-l>")

-- Tab navigation
vim.keymap.set("n", "<C-w><C-h>", "<cmd> silent tabprevious<CR>")
vim.keymap.set("t", "<C-w><C-h>", "<C-\\><C-o>:tabprevious<CR>")
vim.keymap.set("n", "<C-w><C-l>", "<cmd> silent tabnext<CR>")
vim.keymap.set("t", "<C-w><C-l>", "<C-\\><C-o>:tabnext<CR>")

-- Close tab
vim.keymap.set("n", "<C-w>q", "<cmd> tabclose<CR>")
vim.keymap.set("t", "<C-w>q", "<C-\\><C-n>:tabclose<CR>")

-- Close all tabs except current one
vim.keymap.set("n", "<C-w>q", "<cmd> tabonly<CR>")
vim.keymap.set("t", "<C-w>q", "<C-\\><C-n>:tabonly<CR>")

-- Open a new tab
vim.keymap.set("n", "<C-w>N", "<cmd> tabnew<CR>")
vim.keymap.set("t", "<C-w>N", "<C-\\><C-n>:tabnew<CR>")

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
vim.keymap.set("t", "<C-w>1", "<C-\\><C-n>:tabn1<CR>")
vim.keymap.set("t", "<C-w>2", "<C-\\><C-n>:tabn2<CR>")
vim.keymap.set("t", "<C-w>3", "<C-\\><C-n>:tabn3<CR>")
vim.keymap.set("t", "<C-w>4", "<C-\\><C-n>:tabn4<CR>")
vim.keymap.set("t", "<C-w>5", "<C-\\><C-n>:tabn5<CR>")
vim.keymap.set("t", "<C-w>6", "<C-\\><C-n>:tabn6<CR>")
vim.keymap.set("t", "<C-w>7", "<C-\\><C-n>:tabn7<CR>")
vim.keymap.set("t", "<C-w>8", "<C-\\><C-n>:tabn8<CR>")
vim.keymap.set("t", "<C-w>9", "<C-\\><C-n>:tabn9<CR>")
vim.keymap.set("t", "<C-w>0", "<C-\\><C-n>:tablast<CR>")

-- Enter normal-mode in nvim terminal
vim.keymap.set("t", "<C-x>", "<C-\\><C-n>")

-- Exit the current window
vim.keymap.set("n", "<C-q>", "<cmd> silent q<CR>")

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
vim.keymap.set("n", "<C-t>s", ":20 split new<CR>:term<CR>i")
vim.keymap.set("n", "<C-t>v", ":100 vsplit new<CR>:term<CR>i")
vim.keymap.set("n", "<C-t>t", ":tabnew<CR>:term<CR>i")
vim.keymap.set("t", "<C-t>t", "<C-\\><C-o>:tabnew<CR>:term<CR>i")

-- Git commands 
vim.keymap.set("n", "<leader>gg",  "<cmd> silent Git<CR>")
vim.keymap.set("n", "<leader>gcc", "<cmd> silent G commit<CR>")
vim.keymap.set("n", "<leader>gce", "<cmd> silent G commit --amend --no-edit<CR>")
vim.keymap.set("n", "<leader>gca", "<cmd> silent G commit --amend<CR>")

-- Replace current word in current file
vim.keymap.set("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Replace visual selection in current file
vim.keymap.set("v", "<leader>rp", [["ky:%s/<C-r>=@k<CR>/<C-r>=@k<CR>/gI<Left><Left><Left>]])

-- Show all commits
vim.keymap.set('n', '<leader>gv', "<cmd> silent GV<CR>")
