-- This file can be loaded by calling `require('plugins')` from your init.lua

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use 'navarasu/onedark.nvim'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use 'nvim-treesitter/nvim-treesitter-context'

    use 'mbbill/undotree'

    vim.cmd("let g:coc_config_home = '~/'")
    use {'neoclide/coc.nvim', branch = 'release'}

    -- use {
    --     'VonHeikemen/lsp-zero.nvim',
    --     branch = 'v2.x',
    --     requires = {
    --         -- LSP Support
    --         {'neovim/nvim-lspconfig'},             -- Required
    --         {                                      -- Optional
    --             'williamboman/mason.nvim',
    --             run = function()
    --                 pcall(vim.cmd, 'MasonUpdate')
    --             end,
    --         },
    --         {'williamboman/mason-lspconfig.nvim'}, -- Optional

    --         -- Autocompletion
    --         {'hrsh7th/nvim-cmp'},     -- Required
    --         {'hrsh7th/cmp-nvim-lsp'}, -- Required
    --         {'L3MON4D3/LuaSnip'},     -- Required
    --     }
    -- }

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        }
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}

    use 'vim-test/vim-test'
    use 'michaeljsmith/vim-indent-object'
    use 'romainl/vim-cool'
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'
    use 'tpope/vim-commentary'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-abolish'
    use 'tpope/vim-obsession'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'tpope/vim-dadbod'
    use 'kristijanhusak/vim-dadbod-ui'
    use 'junegunn/gv.vim'
    use 'Raimondi/delimitMate'
    use 'christoomey/vim-tmux-navigator'
    use 'pixelneo/vim-python-docstring'
    use 'honza/vim-snippets'
    use 'rhysd/conflict-marker.vim'
    use 'szw/vim-maximizer'

    use {
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    }

end)
