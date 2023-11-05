return {
  "mg979/vim-visual-multi",
  init = function()
    vim.g.VM_set_statusline = 0 -- disable VM's statusline updates to prevent clobbering
    vim.g.VM_silent_exit = 1    -- because the status line already tells me the mode
  end,
  config = function()
    vim.cmd([[
      let g:VM_Mono_hl   = 'DiffText'
      let g:VM_Extend_hl = 'Visual'
      let g:VM_Cursor_hl = 'Visual'
      let g:VM_Insert_hl = 'DiffChange'
    ]])
  end
}
