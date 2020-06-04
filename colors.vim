" TEMP open color test
nnoremap tt :so $VIMRUNTIME/syntax/hitest.vim<CR>

" ------------------------------------------------------------------------------
"  gutter
" ------------------------------------------------------------------------------

hi SignColumn ctermbg=None

hi GitGutterAdd ctermbg=None
hi GitGutterChange ctermbg=None
hi GitGutterChangeDelete ctermbg=None
hi GitGutterDelete ctermbg=None

hi Error ctermfg=red

" ------------------------------------------------------------------------------
"  floating windows
" ------------------------------------------------------------------------------

hi Pmenu ctermbg=0 ctermfg=white
