" open color tests
nnoremap tt :so $VIMRUNTIME/syntax/hitest.vim<CR>
nnoremap 33 :so $VIMRUNTIME/syntax/colortest.vim<CR>
nnoremap 44 :call g:Color256test()<CR>

fu! g:Color256test()
  new
  let num = 255
  while num >= 0
    exec 'hi col_'.num.' ctermbg='.num.' ctermfg=white'
    exec 'syn match col_'.num.' "ctermbg='.num.':...." containedIn=ALL'
    call append(0, 'ctermbg='.num.':....')
    let num = num - 1
  endwhile
  set ro
  set nomodified
endfunction

let s:c0 = '0'   " 0 black
let s:c1 = '1'   " 1 red
let s:c2 = '2'   " 2 green
let s:c3 = '3'   " 3 yellow
let s:c4 = '4'   " 4 blue
let s:c5 = '5'   " 5 magenta
let s:c6 = '6'   " 6 cyan
let s:c7 = '7'   " 7 white

let s:c8 = '8'   " 8 black - light
let s:c9 = '9'   " 9 red - light
let s:c10 = '10' " 10 green - light
let s:c11 = '11' " 11 yellow - light
let s:c12 = '12' " 12 blue - light
let s:c13 = '13' " 13 magenta - light
let s:c14 = '14' " 14 cyan - light
let s:c15 = '15' " 15 white - light

let s:fg = s:c7
let s:fgalt = s:c15
let s:bg = s:c0
let s:bgalt = s:c8
let s:primary = s:c1
let s:secondary = s:c5
let s:tertiary = s:c4
let s:warningfg = s:fg
let s:warningbg = s:c11

" subtle bg
let s:chi = s:c8

" ------------------------------------------------------------------------------
"  gutter, file explorer, and git
" ------------------------------------------------------------------------------

let s:gitadd = s:c10     " light green
let s:gitmodify = s:c12  " light blue
let s:gitdelete = s:c9   " light red

" prevent git gutter issues
hi SignColumn ctermbg=None

" git gutter
exe 'hi GitGutterAdd ctermbg=None ctermfg='.s:gitadd
exe 'hi GitGutterChange ctermbg=None ctermfg='.s:gitmodify
exe 'hi GitGutterChangeDelete ctermbg=None ctermfg='.s:gitdelete
exe 'hi GitGutterDelete ctermbg=None ctermfg='.s:gitdelete

augroup nerdtree_highlight
  au!
  exe 'au Filetype nerdtree hi Directory ctermfg='.s:c9.' cterm=bold'
  exe 'au Filetype nerdtree hi CursorLine cterm=Bold ctermbg='.s:c9.' ctermfg='.s:chi
  exe 'au Filetype nerdtree hi NERDTreeCWD ctermfg='.s:c9.' cterm=bold'
augroup end

exe 'hi GitConflictHead ctermbg='.s:gitadd.' cterm=bold ctermfg=black'
exe 'hi GitConflictMiddle ctermbg='.s:gitdelete.' ctermfg=black'
exe 'hi GitConflictOrigin ctermbg='.s:gitmodify.' cterm=bold ctermfg=black'

" ------------------------------------------------------------------------------
"  line numbers
" ------------------------------------------------------------------------------

exe 'hi LineNr term=Bold ctermfg='.s:fg

" ------------------------------------------------------------------------------
"  floating windows
" ------------------------------------------------------------------------------

" command selection (e.g. file tab selection)
exe 'hi Pmenu ctermbg='.s:bg.' ctermfg='.s:fg
exe 'hi PmenuSel ctermbg='.s:c1.' ctermfg='.s:bg

" terminal/floating window border
exe 'hi WindowBorder ctermfg='.s:fg

" ------------------------------------------------------------------------------
"  buffers
" ------------------------------------------------------------------------------

" vertical line divider
exe 'hi VertSplit ctermfg='.s:bg.' ctermbg='.s:fg

" text selection
if exists('g:theme') && g:theme == 'light'
  exe 'hi Visual ctermfg='.s:bg.' ctermbg='.s:fg
else
  exe 'hi Visual ctermbg='.s:c14.' ctermfg='.s:fgalt
endif

" doesn't seem to work and gets overridden by NonText hi group
" trailing whitespace
" hi Trailing ctermfg=DarkGray
" match Trailing /\s\+$/
exe 'hi NonText ctermfg='.s:fg

" ------------------------------------------------------------------------------
"  cursor and surrounding
" ------------------------------------------------------------------------------

" matching parenthesis
exe 'hi MatchParen ctermfg='.s:bg.' ctermbg='.s:primary.' cterm=Bold'

" inc search
exe 'hi Search ctermfg='.s:bg.' ctermbg='.s:primary

" ------------------------------------------------------------------------------
"  status bar
" ------------------------------------------------------------------------------

hi clear StatusLine

" status line main
exe 'hi StatusLine ctermbg='.s:bg.' ctermfg='.s:fg
exe 'hi StatusLineNC ctermfg='.s:bg

" status line file name
exe 'hi FileName ctermfg='.s:fgalt

let s:cmn = s:c1 " red
let s:cmi = s:c12 " light blue
let s:cmv = s:c14 " light cyan
let s:cmc = s:c10 " light green
let s:cmt = s:c12 " light blue

fu! StatusLineMode()
  let l:bg = s:cmn
  let l:fg = s:fgalt
  let l:mode = mode()

  if (l:mode == 'n')
    let l:mode = 'NORMAL'

  elseif (l:mode == 'i')
    let l:bg = s:cmi
    let l:fg = s:fgalt
    let l:mode = 'INSERT'

  elseif (l:mode == 'v')
    let l:bg = s:cmv
    let l:fg = s:fgalt
    let l:mode = 'VISUAL'

  elseif (l:mode == 'c')
    let l:bg = s:cmc
    let l:fg = s:fgalt
    let l:mode = 'COMMAND'

  elseif (l:mode == 't')
    let l:bg = s:cmt
    let l:fg = s:fgalt
    let l:mode = 'TERMINAL'

  en

  exe 'hi Mode ctermfg='.l:fg.' ctermbg='.l:bg
  return l:mode
endfunction
exe 'hi InactiveMode ctermfg='.s:fgalt.' ctermbg='.s:bgalt

" ------------------------------------------------------------------------------
"  folds
" ------------------------------------------------------------------------------

for highlight in ['Folded', 'vimFold', 'FoldColum']
  exe 'hi '.highlight.' cterm=bold ctermfg='.s:bg.' ctermbg='.s:c14
endfor
