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

let s:c0 = 'black'
let s:c7 = 'lightgrey'
let s:c8 = 'darkgrey'
let s:c9 = 'blue'
let s:c10 = 'green'
let s:c11 = 'cyan'
let s:c12 = 'red'
let s:c13 = 'magenta'
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
hi ALEStyleWarning ctermbg=yellow ctermfg=black
hi ALEWarning ctermbg=yellow ctermfg=black
hi ALEInfo ctermbg=yellow ctermfg=black

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

let s:hi_doc = 'Blue'
let s:hi_media = 'Magenta'

call NERDTreeHighlightFile('md', s:hi_doc, 'none')
call NERDTreeHighlightFile('json', s:hi_doc, 'none')
call NERDTreeHighlightFile('lock', s:hi_doc, 'none')
call NERDTreeHighlightFile('yml', s:hi_doc, 'none')
call NERDTreeHighlightFile('txt', s:hi_doc, 'none')

call NERDTreeHighlightFile('html', 'brown', 'none')

call NERDTreeHighlightFile('css', 'LightBlue', 'none')
call NERDTreeHighlightFile('scss', 'LightMagenta', 'none')
call NERDTreeHighlightFile('js', 'Yellow', 'none')
call NERDTreeHighlightFile('jsx', 'Yellow', 'none')
call NERDTreeHighlightFile('ts', 'DarkCyan', 'none')
call NERDTreeHighlightFile('tsx', 'DarkCyan', 'none')

call NERDTreeHighlightFile('vim', 'lightgreen', 'none')

call NERDTreeHighlightFile('gif', s:hi_media, 'none')
call NERDTreeHighlightFile('png', s:hi_media, 'none')
call NERDTreeHighlightFile('jpg', s:hi_media, 'none')
call NERDTreeHighlightFile('svg', s:hi_media, 'none')
call NERDTreeHighlightFile('mp4', s:hi_media, 'none')
call NERDTreeHighlightFile('pdf', s:hi_media, 'none')
call NERDTreeHighlightFile('doc', s:hi_media, 'none')
call NERDTreeHighlightFile('docx', s:hi_media, 'none')
call NERDTreeHighlightFile('otf', s:hi_media, 'none')
call NERDTreeHighlightFile('ttf', s:hi_media, 'none')
call NERDTreeHighlightFile('woff', s:hi_media, 'none')
call NERDTreeHighlightFile('woff2', s:hi_media, 'none')

" file explorer entry highlight
hi clear Cursorline
exe 'hi Cursorline term=Bold ctermbg='.s:chi

" ------------------------------------------------------------------------------
"  line numbers
" ------------------------------------------------------------------------------

exe 'hi LineNr term=Bold ctermfg='.s:c8

" ------------------------------------------------------------------------------
"  floating windows
" ------------------------------------------------------------------------------

exe 'hi Pmenu ctermbg='.s:chide.' ctermfg=White'
hi PmenuSel ctermfg=LightBlue

" terminal/floating window border
exe 'hi WindowBorder ctermfg='.s:c11

" ------------------------------------------------------------------------------
"  buffers
" ------------------------------------------------------------------------------

exe 'hi VertSplit ctermfg='.s:chide.' ctermbg='.s:chide
exe 'hi NonText ctermfg='.s:chide

" ------------------------------------------------------------------------------
"  cursor and surrounding
" ------------------------------------------------------------------------------

hi Blamer ctermfg=DarkGray
hi MatchParen ctermfg=Black ctermbg=Magenta cterm=Bold

hi Search ctermbg=blue

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

  exe 'hi Mode ctermfg='.s:c0.' ctermbg='.l:bg.' cterm=Bold'
  return l:mode
endfunction

