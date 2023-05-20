vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "gp", "\"_dp")
vim.keymap.set("t", "<C-x>", "<C-\\><C-n>")

vim.keymap.set("n", "<C-q>", "<cmd> silent q<CR>")
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("i", "<C-p>", "<C-r>+")

vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("t", "<C-h>", "<C-w><C-h>")
vim.keymap.set("t", "<C-j>", "<C-w><C-j>")
vim.keymap.set("t", "<C-k>", "<C-w><C-k>")
vim.keymap.set("t", "<C-l>", "<C-w><C-l>")

vim.keymap.set("n", "<C-t>s", ":20 split new<CR>:term<CR>i")
vim.keymap.set("n", "<C-t>v", ":100 vsplit new<CR>:term<CR>i")
vim.keymap.set("n", "<C-t>t", ":tabnew<CR>:term<CR>i")

vim.keymap.set("n", "<leader>gg",  "<cmd> silent Git<CR>")
vim.keymap.set("n", "<leader>gcc", "<cmd> silent G commit<CR>")
vim.keymap.set("n", "<leader>gce", "<cmd> silent G commit --amend --no-edit<CR>")
vim.keymap.set("n", "<leader>gca", "<cmd> silent G commit --amend<CR>")

vim.keymap.set("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>nn", "<cmd> silent NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>nf", "<cmd> silent NvimTreeFindFile<CR>")
