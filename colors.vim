" TEMP open color test
nnoremap tt :so $VIMRUNTIME/syntax/hitest.vim<CR>
nnoremap 11 :so $VIMRUNTIME/syntax/colortest.vim<CR>

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

let s:c8 = 'darkgrey'

" ------------------------------------------------------------------------------
"  gutter, file explorer, and blame
" ------------------------------------------------------------------------------

exe 'hi LineNr ctermfg='.s:c8

hi SignColumn ctermbg=None

hi GitGutterAdd ctermbg=None ctermfg=Green
hi GitGutterChange ctermbg=None ctermfg=Blue
hi GitGutterChangeDelete ctermbg=None ctermfg=Red
hi GitGutterDelete ctermbg=None ctermfg=Red

hi Error cterm=bold

hi Directory ctermfg=White

" TODO not loading initially
" https://github.com/preservim/nerdtree/issues/433#issuecomment-92590696
" https://github.com/tiagofumo/vim-nerdtree-syntax-highlight
fun! NERDTreeHighlightFile(ext, fg, bg)
  exe 'au Filetype nerdtree highlight '.a:ext.' ctermbg='.a:bg.' ctermfg='.a:fg.''
  exe 'au Filetype nerdtree syn match '.a:ext.' #^\s\+.*'.a:ext.'$#'
endfunction

" TODO special case for dots
" exe 'au Filetype nerdtree highlight dot ctermbg=none ctermfg='.s:c8
" exe 'au Filetype nerdtree syn match dot #\..*#'

call NERDTreeHighlightFile('md', 'Blue', 'none')
call NERDTreeHighlightFile('json', 'Blue', 'none')
call NERDTreeHighlightFile('lock', 'Blue', 'none')
call NERDTreeHighlightFile('yml', 'Blue', 'none')

call NERDTreeHighlightFile('html', 'brown', 'none')

call NERDTreeHighlightFile('css', 'LightBlue', 'none')
call NERDTreeHighlightFile('scss', 'LightMagenta', 'none')
call NERDTreeHighlightFile('js', 'Yellow', 'none')
call NERDTreeHighlightFile('jsx', 'Yellow', 'none')
call NERDTreeHighlightFile('ts', 'DarkCyan', 'none')
call NERDTreeHighlightFile('tsx', 'DarkCyan', 'none')

" ------------------------------------------------------------------------------
"  floating windows
" ------------------------------------------------------------------------------

hi Pmenu ctermbg=0 ctermfg=White
hi PmenuSel ctermfg=LightBlue

" ------------------------------------------------------------------------------
"  buffers
" ------------------------------------------------------------------------------

hi VertSplit ctermfg=0 ctermbg=0

" ------------------------------------------------------------------------------
"  cursor and surrounding
" ------------------------------------------------------------------------------

hi Blamer ctermfg=DarkGray

