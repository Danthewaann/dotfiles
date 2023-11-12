return {
  "puremourning/vimspector",
  init = function()
    -- Must define this before loading vimspector
    vim.g.vimspector_enable_mappings = "HUMAN"
  end,
  config = function()
    vim.cmd [[
      " Open vimspector settings
      command! VimspectorConfig :e ~/.vimspector.json

      let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-node-debug2', 'delve' ]
      let g:vimspector_bottombar_height = 25

      " For custom UI stuff below
      " keep track of when we moved the terminal so we
      " don't keep moving it when restarting a vimspector session
      let g:moved_terminal = 0

      " For normal mode - the word under the cursor
      nmap <leader>vi <Plug>VimspectorBalloonEval

      " For visual mode, the visually selected text
      xmap <leader>vi <Plug>VimspectorBalloonEval

      nmap <leader><F11> <Plug>VimspectorUpFrame
      nmap <leader><F12> <Plug>VimspectorDownFrame
      nmap <leader>vb <Plug>VimspectorBreakpoints
      nmap <leader>vd <Plug>VimspectorDisassemble

      nnoremap <leader>vc <Plug>VimspectorContinue
      nnoremap <leader>vr <Plug>VimspectorRestart

      function! ResetVimspector() abort
          execute 'VimspectorReset'
          let g:moved_terminal = 0
      endfunction

      nnoremap <silent><leader>vq :call ResetVimspector()<CR>

      let g:vimspector_sign_priority = {
                  \    'vimspectorBP':             999,
                  \    'vimspectorBPCond':         2,
                  \    'vimspectorBPLog':          2,
                  \    'vimspectorBPDisabled':     1,
                  \    'vimspectorPC':             999,
                  \    'vimspectorPCBP':           1001,
                  \    'vimspectorCurrentThread':  1000,
                  \    'vimspectorCurrentFrame':   1000,
                  \ }

      function! s:CustomiseUI()
          let wins = g:vimspector_session_windows

          " Enable keyboard-hover for vars and watches
          call win_gotoid( g:vimspector_session_windows.variables )
          nmap <silent><buffer> <localleader>o <Plug>VimspectorBalloonEval
          nmap <silent><buffer> <Tab> <Enter>

          call win_gotoid( g:vimspector_session_windows.watches )
          nmap <silent><buffer> <localleader>o <Plug>VimspectorBalloonEval

          call win_gotoid( g:vimspector_session_windows.code )
          nmap <silent><buffer> <localleader>o <Plug>VimspectorBalloonEval

          let console_win = g:vimspector_session_windows.output
          call win_gotoid( console_win )
          inoremap <silent><buffer> <C-J> <C-W>j
          inoremap <silent><buffer> <C-K> <C-W>k
          inoremap <silent><buffer> <C-L> <C-W>l
          inoremap <silent><buffer> <C-H> <C-W>h
          inoremap <silent><buffer> <F5> <C-O>:call vimspector#Continue()<CR>
          inoremap <silent><buffer> <F10> <C-O>:call vimspector#StepOver()<CR>
          inoremap <silent><buffer> <F11> <C-O>:call vimspector#StepInto()<CR>
          inoremap <silent><buffer> <F12> <C-O>:call vimspector#StepOut()<CR>
          setlocal scrolloff=0
          setlocal modifiable
          resize-10
      endfunction

      function s:SetUpTerminal()
          if !has_key( g:vimspector_session_windows, 'terminal' )
              " There's a neovim bug which means that this doesn't work in neovim
              return
          endif
          let terminal_win = g:vimspector_session_windows.terminal

          " Add binds for easier navigation
          call win_gotoid( terminal_win )
          tnoremap <silent><buffer> <C-J> <C-W><C-J>
          tnoremap <silent><buffer> <C-K> <C-W><C-K>
          tnoremap <silent><buffer> <C-L> <C-W><C-L>
          tnoremap <silent><buffer> <C-H> <C-W><C-H>

          " Swap terminal position with console position
          " only works when I have a vertical tmux pane open
          " if g:moved_terminal != 1
          "     resize-5
          "     execute 'wincmd x'
          "     let g:moved_terminal = 1
          " endif
      endfunction

      let s:mapped = {}

      function! s:OnJumpToFrame() abort
          let buf_nr = bufnr()
          let file_extension = expand('%:e')
          " Set filetype to python for now to get syntax highlighting
          " when doing remote debugging via a docker container
          if file_extension =~# "py"
              setlocal filetype=python
          endif

          if has_key(s:mapped, string(buf_nr))
              return
          endif

          nmap <silent><buffer> o <Plug>VimspectorBalloonEval

          let s:mapped[string(buf_nr)] = {'modifiable': &modifiable}
      endfunction

      function! s:OnDebugEnd() abort
          let original_buf = bufnr()
          let hidden = &hidden
          augroup VimspectorSwapExists
              au!
              autocmd SwapExists * let v:swapchoice='o'
          augroup END

          try
              set hidden
              for bufnr in keys(s:mapped)
                  try
                      execute 'buffer' bufnr
                      silent! nunmap <buffer> o

                      let &l:modifiable = s:mapped[ bufnr ][ 'modifiable' ]
                  endtry
              endfor
          finally
              execute 'noautocmd buffer' original_buf
              let &hidden = hidden
          endtry

          au! VimspectorSwapExists

          let s:mapped = {}
      endfunction

      augroup MyVimspectorCustomisation
          autocmd!
          autocmd User VimspectorUICreated call s:CustomiseUI()
          autocmd User VimspectorTerminalOpened call s:SetUpTerminal()
          autocmd User VimspectorJumpedToFrame call s:OnJumpToFrame()
          autocmd User VimspectorDebugEnded ++nested call s:OnDebugEnd()
      augroup END

      " Allow for command history in VimspectorPrompt
      "
      " from https://github.com/puremourning/vimspector/issues/52#issuecomment-699027787
      augroup vimspector_command_history
          autocmd!
          autocmd FileType VimspectorPrompt call InitializeVimspectorCommandHistory()
      augroup end

      function! InitializeVimspectorCommandHistory()
          if !exists('b:vimspector_command_history')
              inoremap <silent> <buffer> <CR> <C-o>:call VimspectorCommandHistoryAdd()<CR>
              inoremap <silent> <buffer> <Up> <C-o>:call VimspectorCommandHistoryUp()<CR>
              inoremap <silent> <buffer> <Down> <C-o>:call VimspectorCommandHistoryDown()<CR>
              inoremap <silent> <buffer> <C-c> <C-c>dd:startinsert<CR>
              let b:vimspector_command_history = []
              let b:vimspector_command_history_pos = 0
          endif
      endfunction

      function! VimspectorCommandHistoryAdd()
          let line = trim(getline('.'))
          if line != '>'
              call add(b:vimspector_command_history, line)
              let b:vimspector_command_history_pos = len(b:vimspector_command_history)
          endif
          call feedkeys("\<CR>i", 'tn')
      endfunction

      function! VimspectorCommandHistoryUp()
          if len(b:vimspector_command_history) == 0 || b:vimspector_command_history_pos == 0
              return
          endif
          call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
          call feedkeys("\<C-o>A", 'tn')
          let b:vimspector_command_history_pos = b:vimspector_command_history_pos - 1
      endfunction

      function! VimspectorCommandHistoryDown()
          if b:vimspector_command_history_pos == len(b:vimspector_command_history)
              return
          endif
          call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
          call feedkeys("\<C-o>A", 'tn')
          let b:vimspector_command_history_pos = b:vimspector_command_history_pos + 1
      endfunction
    ]]
  end
}
