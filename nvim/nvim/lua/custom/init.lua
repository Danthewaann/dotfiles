-- [[ Setting colourscheme ]]
require("custom.colourscheme")

-- [[ Setting options ]]
require("custom.opts")

-- [[ Setting keymaps ]]
require("custom.keymaps")

-- [[ Setting commands ]]
require("custom.commands")

-- [[ Setting auto commands ]]
require("custom.autocmds")

-- [[ Custom breakpoints code ]]
require("custom.breakpoints")

-- [[ Custom tmux code ]]
require("custom.tmux")

-- [[ Builtin optional plugins ]]
vim.cmd("packadd nohlsearch")
vim.cmd("packadd nvim.difftool")
vim.cmd("packadd nvim.undotree")
