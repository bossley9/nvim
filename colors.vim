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
let s:c9 = 'blue'
let s:c10 = 'green'
let s:c12 = 'red'

" ------------------------------------------------------------------------------
"  gutter, file explorer, and blame
" ------------------------------------------------------------------------------

let s:gitadd = s:c10
let s:gitmodify = s:c9
let s:gitdelete = s:c12

exe 'hi LineNr ctermfg='.s:c8

hi SignColumn ctermbg=None

exe 'hi GitGutterAdd ctermbg=None ctermfg='.s:gitadd
exe 'hi GitGutterChange ctermbg=None ctermfg='.s:gitmodify
exe 'hi GitGutterChangeDelete ctermbg=None ctermfg='.s:gitdelete
exe 'hi GitGutterDelete ctermbg=None ctermfg='.s:gitdelete

hi Error cterm=bold

hi Directory ctermfg=White

augroup nerdtreeconcealbrackets
  au!
  au FileType nerdtree syntax match hideBracketsInNerdTree
    \ "\]" contained conceal containedin=ALL cchar=""
  au FileType nerdtree syntax match hideBracketsInNerdTree
    \ "\[" contained conceal containedin=ALL
  au FileType nerdtree setlocal conceallevel=3
  au FileType nerdtree setlocal concealcursor=nvic
augroup end

" TODO overwritten by file highlight
exe 'hi NERDTreeGitStatusModified ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusStaged ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusRenamed ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusUnmerged ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusUntracked ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusDirDirty ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusDirClean ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusIgnored ctermfg='.s:gitmodify

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

" file explorer entry highlight
hi clear Cursorline
hi Cursorline term=Bold ctermbg=8

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

