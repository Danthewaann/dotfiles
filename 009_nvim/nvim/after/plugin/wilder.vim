" call wilder#setup({
"       \ 'modes': [':', '/', '?'],
"       \ 'enable_cmdline_enter': 0,
"       \ })
"
" " 'border'            : 'single', 'double', 'rounded' or 'solid'
" "                     : can also be a list of 8 characters,
" "                     : see :h wilder#popupmenu_border_theme() for more details
" " 'highlights.border' : highlight to use for the border`
" call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
"       \ 'highlights': {
"       \   'border': 'Normal',
"       \ },
"       \ 'border': 'rounded',
"       \ })))
"
" call wilder#set_option('pipeline', [
"       \   wilder#branch(
"       \     wilder#cmdline_pipeline(),
"       \     wilder#search_pipeline(),
"       \   ),
"       \ ])
"
