-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  {
    "folke/lazy.nvim",
    -- Pin to this version as nvim-dap-python doesn't build due to this commit:
    -- https://github.com/folke/lazy.nvim/commit/147f5a3f55b5491bbc77a55ce846ef5eb575fa42
    version = "v11.17.1",
  },
  { import = "plugins.core" },
  { import = "plugins.cosmetic" },
  { import = "plugins.extras" },
}, {
  ui = {
    border = "rounded"
  },
  -- Don't notify changes as it gets annoying
  change_detection = {
    notify = false,
  },
})

-- [[ Require custom setup ]]
require("custom")
