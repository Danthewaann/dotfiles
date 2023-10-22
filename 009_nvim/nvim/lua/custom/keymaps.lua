-- Treat <space> as a noop
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Open fold at cursor recursively
vim.keymap.set('n', 'l', "foldclosed('.') == -1 ? 'l' : 'zO'", { expr = true, silent = true })

-- Move the current selection up or down a line
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep the cursor in the same place when joining lines
vim.keymap.set("n", "J", "mzJ`z")

-- Map enter to break the current line
vim.keymap.set("n", "<CR>", "i<CR><ESC>k$")

-- Paste over visual selection and yank to empty register
vim.keymap.set({ 'v', 'x' }, 'p', '"_dP')

-- Re-select pasted text
vim.keymap.set("n", "gp", "`[v`]")

-- Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
-- which is the default
vim.keymap.set("n", "Y", "y$")

-- Go to the start and end of the line
vim.keymap.set("n", "H", "0")
vim.keymap.set("n", "L", "$")
vim.keymap.set("v", "H", "_")
vim.keymap.set("v", "L", "g_")

-- Prevent the cursor from jumping to the start of a selection after yanking it
vim.keymap.set("v", "y", "ygv<Esc>")

-- Go to alernative buffer
vim.keymap.set("n", "<BS>", ":b#<CR>", { silent = true })

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
vim.keymap.set("n", "<C-h>", ":<C-U>TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", ":<C-U>TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", ":<C-U>TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", ":<C-U>TmuxNavigateRight<CR>", { silent = true })
vim.keymap.set("t", "<C-h>", "<cmd> wincmd h<CR>")
vim.keymap.set("t", "<C-j>", "<cmd> wincmd j<CR>")
vim.keymap.set("t", "<C-k>", "<cmd> wincmd k<CR>")
vim.keymap.set("t", "<C-l>", "<cmd> wincmd l<CR>")

-- Tab navigation
vim.keymap.set("n", "<C-w><C-h>", "<cmd> silent tabprevious<CR>")
vim.keymap.set("n", "<C-w><C-l>", "<cmd> silent tabnext<CR>")
vim.keymap.set("t", "<C-w><C-h>", "<cmd> tabprevious<CR>", { silent = true })
vim.keymap.set("t", "<C-w><C-l>", "<cmd> tabnext<CR>", { silent = true })

-- Close tab
vim.keymap.set("n", "<C-w>q", "<cmd> tabclose<CR>")
vim.keymap.set("t", "<C-w>q", "<cmd> silent tabclose<CR>")

-- Close all tabs except current one
vim.keymap.set("n", "<C-w>to", "<cmd> tabonly<CR>")
vim.keymap.set("t", "<C-w>to", "<cmd> silent tabonly<CR>")

-- Open a new tab
vim.keymap.set("n", "<C-w>N", "<cmd> tabnew<CR>")
vim.keymap.set("t", "<C-w>N", "<cmd> silent tabnew<CR>")

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
vim.keymap.set("t", "<C-w>1", "<cmd> silent tabn1<CR>")
vim.keymap.set("t", "<C-w>2", "<cmd> silent tabn2<CR>")
vim.keymap.set("t", "<C-w>3", "<cmd> silent tabn3<CR>")
vim.keymap.set("t", "<C-w>4", "<cmd> silent tabn4<CR>")
vim.keymap.set("t", "<C-w>5", "<cmd> silent tabn5<CR>")
vim.keymap.set("t", "<C-w>6", "<cmd> silent tabn6<CR>")
vim.keymap.set("t", "<C-w>7", "<cmd> silent tabn7<CR>")
vim.keymap.set("t", "<C-w>8", "<cmd> silent tabn8<CR>")
vim.keymap.set("t", "<C-w>9", "<cmd> silent tabn9<CR>")
vim.keymap.set("t", "<C-w>0", "<cmd> silent tablast<CR>")

-- Move tabs left or right
vim.keymap.set("n", "<C-w>,", "<cmd> silent -tabmove<CR>")
vim.keymap.set("t", "<C-w>,", "<cmd> silent -tabmove<CR>")
vim.keymap.set("n", "<C-w>.", "<cmd> silent +tabmove<CR>")
vim.keymap.set("t", "<C-w>.", "<cmd> silent +tabmove<CR>")

-- Enter normal-mode in nvim terminal
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>")

-- Exit the current window
vim.keymap.set("n", "<C-q>", "<cmd> silent q<CR>")

-- Treat Ctrl+C exactly like <Esc> in insert mode
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Paste the clipboard contents in insert mode
vim.keymap.set("i", "<C-p>", "<C-r>+")

-- Center screen when moving through search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Open an nvim terminal
vim.keymap.set("n", "<C-t>s", "<cmd> silent 20 split new<CR><cmd> term<CR>")
vim.keymap.set("n", "<C-t>v", "<cmd> silent 100 vsplit new<CR><cmd> term<CR>")
vim.keymap.set("n", "<C-t>t", "<cmd> silent $tabnew<CR><cmd> term<CR>")
vim.keymap.set("t", "<C-t>t", "<C-\\><C-o> <cmd> silent $tabnew <CR><cmd> term<CR>")

-- Git commands
vim.keymap.set("n", "<leader>gpp", "<cmd> Git push<CR>", { desc = '[G]it [P]ush' })
vim.keymap.set("n", "<leader>gpf", "<cmd> Git push --force<CR>", { desc = '[G]it [P]ush [F]orce' })
vim.keymap.set("n", "<leader>gg", "<cmd> silent Git<CR>", { desc = '[G]it [G]et' })
vim.keymap.set("n", "<leader>gcc", "<cmd> silent Git commit<CR>", { desc = '[G]it [C]ommit' })
vim.keymap.set("n", "<leader>gca", "<cmd> silent Git commit --amend<CR>", { desc = '[G]it [C]ommit [A]mend' })
vim.keymap.set("n", "<leader>gce", "<cmd> Git commit --amend --no-edit<CR>", { desc = '[G]it [C]ommit [E]dit' })
vim.keymap.set({ "n", "v" }, "<leader>go", ":GBrowse<CR>", { silent = true, desc = '[G]it [O]pen' })

-- Replace current word in current file
vim.keymap.set("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Replace visual selection in current file
vim.keymap.set("v", "<leader>rp", [["ky:%s/<C-r>=@k<CR>/<C-r>=@k<CR>/gI<Left><Left><Left>]])

-- Show all commits
vim.keymap.set('n', '<leader>gva', ":GV<CR>", { silent = true })

-- Show commits for the current file
vim.keymap.set('n', '<leader>gvf', ":GV!<CR>", { silent = true })

-- Show commits for the visual selection
vim.keymap.set('x', '<leader>gv', ":GV<CR>", { silent = true })

-- Add custom vim-unimpaired like mapping to toggle folds in current window
vim.keymap.set("n", "yof", function()
    if vim.wo.foldenable == true then
        vim.wo.foldenable = false
        print(":setlocal nofoldenable")
    else
        vim.wo.foldenable = true
        print(":setlocal foldenable")
    end
end)