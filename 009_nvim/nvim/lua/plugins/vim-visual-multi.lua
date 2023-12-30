return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  init = function()
    vim.g.VM_set_statusline   = 0 -- disable VM's statusline updates to prevent clobbering
    vim.g.VM_silent_exit      = 1 -- because the status line already tells me the mode
    vim.g.VM_default_mappings = 1
    vim.g.VM_maps             = { ["Find Under"] = "" }
    vim.g.VM_Mono_hl          = "DiffText"
    vim.g.VM_Extend_hl        = "Visual"
    vim.g.VM_Cursor_hl        = "Visual"
    vim.g.VM_Insert_hl        = "DiffChange"
  end,
  config = function()
    vim.keymap.set("n", "<leader>v/", "<Plug>(VM-Start-Regex-Search)", { desc = "[V]isual multi start regex search" })
    vim.keymap.set("n", "<leader>vn", "<Plug>(VM-Find-Under)", { desc = "[V]isual multi find under cursor" })
    vim.keymap.set("n", "<leader>va", "<Plug>(VM-Select-All)", { desc = "[V]isual multi select all under cursor" })
    vim.keymap.set("n", "<C-w><C-j>", "<Plug>(VM-Add-Cursor-Down)", { desc = "[V]isual multi add cursor down" })
    vim.keymap.set("n", "<C-w><C-k>", "<Plug>(VM-Add-Cursor-Up)", { desc = "[V]isual multi add cursor up" })
  end
}
