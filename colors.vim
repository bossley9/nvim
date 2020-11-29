" TEMP open color test
nnoremap tt :so $VIMRUNTIME/syntax/hitest.vim<CR>
nnoremap 33 :so $VIMRUNTIME/syntax/colortest.vim<CR>

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
"  gutter, file explorer, and blame
" ------------------------------------------------------------------------------

let s:gitadd = s:c10     " light green
let s:gitmodify = s:c11  " light yellow
let s:gitdelete = s:c9   " light red

" prevent git gutter issues
hi SignColumn ctermbg=None

" git gutter
exe 'hi GitGutterAdd ctermbg=None ctermfg='.s:gitadd
exe 'hi GitGutterChange ctermbg=None ctermfg='.s:gitmodify
exe 'hi GitGutterChangeDelete ctermbg=None ctermfg='.s:gitdelete
exe 'hi GitGutterDelete ctermbg=None ctermfg='.s:gitdelete

" ALE errors
hi Error cterm=bold
exe 'hi ALEStyleWarning ctermbg='.s:warningbg.' ctermfg='.s:warningfg
exe 'hi ALEWarning ctermbg='.s:warningbg.' ctermfg='.s:warningfg
exe 'hi ALEInfo ctermbg='.s:warningbg.' ctermfg='.s:warningfg

" ???
hi Directory ctermfg=White

" hide nerdtree git brackets
augroup nerdtreeconcealbrackets
  au!
  au FileType nerdtree syntax match hideBracketsInNerdTree
    \ "\]" contained conceal containedin=ALL cchar=""
  au FileType nerdtree syntax match hideBracketsInNerdTree
    \ "\[" contained conceal containedin=ALL
  au FileType nerdtree setlocal conceallevel=3
  au FileType nerdtree setlocal concealcursor=nvic
augroup end

" this is overwritten by filetype highlighting, if present
exe 'hi NERDTreeGitStatusModified ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusStaged ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusRenamed ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusUnmerged ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusUntracked ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusDirDirty ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusDirClean ctermfg='.s:gitmodify
exe 'hi NERDTreeGitStatusIgnored ctermfg='.s:gitmodify

fu! NERDTreeHighlightFile(ext, fg, bg)
  exe 'au Filetype nerdtree hi '.a:ext.' ctermbg='.a:bg.' ctermfg='.a:fg.''
  exe 'au Filetype nerdtree syn match '.a:ext.' #^\s\+.*'.a:ext.'$#'
endfunction

" hide all dotfiles
augroup file_explorer_dot_highlight
  exe 'au Filetype nerdtree hi dot ctermbg=none ctermfg='.s:c8
  " for some strange reason, NERDTree entries are arranged as 
  " (whitespace) + (invisible character) + (file name)
  au Filetype nerdtree match dot #\s\+.\.\S*#
augroup end

let s:cdoc = s:c4
let s:cmedia = s:c5

call NERDTreeHighlightFile('md', s:cdoc, 'none')
call NERDTreeHighlightFile('json', s:cdoc, 'none')
call NERDTreeHighlightFile('lock', s:cdoc, 'none')
call NERDTreeHighlightFile('yml', s:cdoc, 'none')
call NERDTreeHighlightFile('txt', s:cdoc, 'none')
call NERDTreeHighlightFile('tex', s:cdoc, 'none')

call NERDTreeHighlightFile('html', s:c4, 'none')

call NERDTreeHighlightFile('css', s:c12, 'none')
call NERDTreeHighlightFile('scss', s:c13, 'none')
call NERDTreeHighlightFile('js', s:c3, 'none')
call NERDTreeHighlightFile('jsx', s:c3, 'none')
call NERDTreeHighlightFile('ts', s:c6, 'none')
call NERDTreeHighlightFile('tsx', s:c6, 'none')

call NERDTreeHighlightFile('vim', s:c2, 'none')

call NERDTreeHighlightFile('gif', s:cmedia, 'none')
call NERDTreeHighlightFile('png', s:cmedia, 'none')
call NERDTreeHighlightFile('jpg', s:cmedia, 'none')
call NERDTreeHighlightFile('svg', s:cmedia, 'none')
call NERDTreeHighlightFile('mp4', s:cmedia, 'none')
call NERDTreeHighlightFile('pdf', s:cmedia, 'none')
call NERDTreeHighlightFile('doc', s:cmedia, 'none')
call NERDTreeHighlightFile('docx', s:cmedia, 'none')
call NERDTreeHighlightFile('otf', s:cmedia, 'none')
call NERDTreeHighlightFile('ttf', s:cmedia, 'none')
call NERDTreeHighlightFile('woff', s:cmedia, 'none')
call NERDTreeHighlightFile('woff2', s:cmedia, 'none')

" file explorer entry highlight
hi clear Cursorline
exe 'hi Cursorline term=Bold ctermbg='.s:chi.' ctermfg='.s:fg

" ------------------------------------------------------------------------------
"  line numbers
" ------------------------------------------------------------------------------

exe 'hi LineNr term=Bold ctermfg='.s:chi

" ------------------------------------------------------------------------------
"  floating windows
" ------------------------------------------------------------------------------

" command selection (e.g. file tab selection)
exe 'hi Pmenu ctermbg='.s:bg.' ctermfg='.s:fg
exe 'hi PmenuSel ctermbg='.s:fg

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
  exe 'hi Visual ctermbg='.s:chi
endif

" doesn't seem to work and gets overridden by NonText hi group
" trailing whitespace
" hi Trailing ctermfg=DarkGray
" match Trailing /\s\+$/
exe 'hi NonText ctermfg='.s:fg

" ------------------------------------------------------------------------------
"  cursor and surrounding
" ------------------------------------------------------------------------------

" git blame
exe 'hi Blamer ctermfg='.s:chi

" matching parenthesis
exe 'hi MatchParen ctermfg='.s:bg.' ctermbg='.s:primary.' cterm=Bold'

" slash search
exe 'hi Search ctermfg='.s:bg.' ctermbg='.s:primary

" ------------------------------------------------------------------------------
"  status bar
" ------------------------------------------------------------------------------

hi clear StatusLine

" status line main
exe 'hi StatusLine ctermbg='.s:bg.' ctermfg='.s:fg

" status line inactive
exe 'hi StatusLineNC ctermbg='.s:tertiary.' ctermfg='.s:bg

" status line file name
exe 'hi FileName ctermfg='.s:fg.' cterm=Bold'

let s:cmn = s:c1 " red
let s:cmi = s:c12 " light blue
let s:cmv = s:c3 " yellow
let s:cmc = s:c10 " light green
let s:cmt = s:c12 " light blue

fu! StatusLineMode()
  let l:bg = s:cmn
  let l:fg = s:fg
  let l:mode = mode()

  if (l:mode == 'n')
    let l:mode = 'NORMAL'

  elseif (l:mode == 'i')
    let l:bg = s:cmi
    let l:fg = s:fg
    let l:mode = 'INSERT'

  elseif (l:mode == 'v')
    let l:bg = s:cmv
    let l:fg = s:fg
    let l:mode = 'VISUAL'

  elseif (l:mode == 'c')
    let l:bg = s:cmc
    let l:fg = s:fg
    let l:mode = 'COMMAND'

  elseif (l:mode == 't')
    let l:bg = s:cmt
    let l:fg = s:fg
    let l:mode = 'TERMINAL'

  en

  " exe 'hi Mode ctermfg='.s:fg.' ctermbg='.l:bg.' cterm=Bold'
  exe 'hi Mode ctermfg='.l:fg.' ctermbg='.l:bg.' cterm=Bold'
  return l:mode
endfunction
