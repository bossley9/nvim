" TEMP open color test
nnoremap tt :so $VIMRUNTIME/syntax/hitest.vim<CR>

" 0 black
" 1 darkblue
" 2 darkgreen
" 3 darkcyan
" 4 darkred
" 5 darkmagenta
" 6 darkyellow
" 7 lightgrey
" 8 darkgrey
" 9 blue
" 10 green
" 11 cyan
" 12 red
" 13 magenta
" 14 yellow
" 15 white

" ------------------------------------------------------------------------------
"  gutter
" ------------------------------------------------------------------------------

hi SignColumn ctermbg=None

hi GitGutterAdd ctermbg=None ctermfg=Green
hi GitGutterChange ctermbg=None ctermfg=Yellow
hi GitGutterChangeDelete ctermbg=None ctermfg=Red
hi GitGutterDelete ctermbg=None ctermfg=Red

hi Error ctermfg=Red ctermbg=Red

" ------------------------------------------------------------------------------
"  floating windows
" ------------------------------------------------------------------------------

hi Pmenu ctermbg=0 ctermfg=White

" ------------------------------------------------------------------------------
"  status bar
" ------------------------------------------------------------------------------

