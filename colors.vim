" TEMP open color test
nnoremap tt :so $VIMRUNTIME/syntax/hitest.vim<CR>
nnoremap 33 :so $VIMRUNTIME/syntax/colortest.vim<CR>

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
let s:c15 = 'white'

let s:chide = 0
let s:chi = 8

" ------------------------------------------------------------------------------
"  gutter, file explorer, and blame
" ------------------------------------------------------------------------------

let s:gitadd = s:c10
let s:gitmodify = s:c9
let s:gitdelete = s:c12

exe 'hi LineNr ctermfg='.s:chi

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
exe 'hi Cursorline term=Bold ctermbg='.s:chi

" ------------------------------------------------------------------------------
"  floating windows
" ------------------------------------------------------------------------------

exe 'hi Pmenu ctermbg='.s:chide.' ctermfg=White'
hi PmenuSel ctermfg=LightBlue

" ------------------------------------------------------------------------------
"  buffers
" ------------------------------------------------------------------------------

exe 'hi VertSplit ctermfg='.s:chide.' ctermbg='.s:chide
exe 'hi NonText ctermfg='.s:chide

" ------------------------------------------------------------------------------
"  cursor and surrounding
" ------------------------------------------------------------------------------

hi Blamer ctermfg=DarkGray

" ------------------------------------------------------------------------------
"  status bar
" ------------------------------------------------------------------------------

hi clear StatusLine

hi StatusLine ctermbg=0 ctermfg=Grey
hi StatusLineNC ctermbg=0 ctermfg=0

exe 'hi FileName ctermfg='.s:c9.' cterm=Bold'

let s:cmn = 'Magenta'
let s:cmi = 'LightBlue'
let s:cmv = 'Yellow'
let s:cmc = 'Green'
let s:cmt = 'DarkBlue'

fu! StatusLineMode()
  let l:bg = s:cmn
  let l:mode = mode()

  if (l:mode == 'n')
    let l:bg = s:cmn
    let l:mode = 'NORMAL'

  elseif (l:mode == 'i')
    let l:bg = s:cmi
    let l:mode = 'INSERT'

  elseif (l:mode == 'v')
    let l:bg = s:cmv
    let l:mode = 'VISUAL'

  elseif (l:mode == 'c')
    let l:bg = s:cmc
    let l:mode = 'COMMAND'

  elseif (l:mode == 't')
    let l:bg = s:cmt
    let l:mode = 'TERMINAL'

  else
    let l:bg = s:cmn
  en

  exe 'hi Mode ctermfg='.s:chide.' ctermbg='.l:bg.' cterm=Bold'
  return l:mode
endfunction

