" Neovim configuration file created by Sam Bossley

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" plugins
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'               " basic Vim settings
Plug 'vim-airline/vim-airline'          " airline bar customization
Plug 'tpope/vim-fugitive'               " git branch on airline
Plug 'airblade/vim-gitgutter'           " git gutter
Plug 'sainnhe/edge'                     " color scheme
Plug 'sheerun/vim-polyglot'             " improved syntax highlighting
Plug 'ctrlpvim/ctrlp.vim'               " fuzzy finder
Plug 'scrooloose/nerdtree'              " file explorer
Plug 'Xuyuanp/nerdtree-git-plugin'      " git in file explorer
Plug 'tpope/vim-commentary'             " commentng shortcut
Plug 'jiangmiao/auto-pairs'             " auto pair inserting

" language syntax

Plug 'alvan/vim-closetag'               " html auto-closing tags
Plug 'mattn/emmet-vim'                  " emmet (shorthand html generation)
Plug 'suy/vim-context-commentstring'    " commenting for React and jsx

" autocompletion

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-tsserver'
Plug 'neoclide/coc-json'
Plug 'neoclide/coc-html'
Plug 'neoclide/coc-css'

call plug#end()

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" plugin settings
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

" airline bar icons
if !exists('g:airline_symbols') | let g:airline_symbols = {} | endif
let g:airline_symbols.linenr = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.whitespace = ''
" if no version control is detected
let g:airline#extensions#branch#empty_message = '<untracked>'
" airline bar
let g:airline#extensions#default#layout = [
\   [ 'a', 'b', 'c' ],
\   [ 'x', 'y', 'z' ]
\ ]
let g:airline_section_c = airline#section#create(['file'])
let g:airline_section_x = airline#section#create(['Ln %l, Col %c'])
let g:airline_section_y = airline#section#create(['filetype'])
let g:airline_section_z = airline#section#create(['ffenc'])
let g:airline_extensions = ['branch', 'tabline']
" show project directory in the tabline
let g:airline#extensions#tabline#buffers_label = expand('%:p:h:t')
" only show path in tab name if it contains another file with the same name
let g:airline#extensions#tabline#formatter = 'unique_tail'
" tabline separators
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ' '
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = ' '

" disable fugitive mappings
let g:fugitive_no_maps = 1

" signcolumn should always display
if has('signcolumn') | set signcolumn='yes' | endif
" git gutter symbols
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '~~'
let g:gitgutter_sign_removed = '--'
" disable gutter keymappings
let g:gitgutter_map_keys = 0
" update gutters every x milliseconds
set updatetime=300

" include more search results in fuzzy finder
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:15,results:15'
" show hidden file results
let g:ctrlp_show_hidden = 1
" fuzzy finder ignore files/folders
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" don't show hidden files in file explorer by default
let NERDTreeShowHidden = 0
" close explorer on file open
let NERDTreeQuitOnOpen = 1
" keep file explorer closed on open
let g:NERDTreeHijackNetrw=0
" set window size
let NERDTreeWinSize = 25
" minimal ui
let NERDTreeMinimalUI = 1
" collapse folders if applicable
let NERDTreeCascadeSingleChildDir = 1
" let file explorer open directory by default
let NERDTreeChDirMode = 1
" specify which files/folders to ignore
let NERDTreeIgnore =  ['^.git$', '^node_modules$']
let NERDTreeIgnore += ['\.vim$[[dir]]', '\~$']
let NERDTreeIgnore += ['\.d$[[dir]]', '\.o$[[file]]', '\.dat$[[file]]', '\.ini$[[file]]']
let NERDTreeIgnore += ['\.png$','\.jpg$','\.gif$','\.mp3$','\.flac$', '\.ogg$', '\.mp4$','\.avi$','.webm$','.mkv$','\.pdf$', '\.zip$', '\.tar.gz$', '\.rar$']

" file explorer git icons
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "~~",
    \ "Staged"    : "?",
    \ "Untracked" : "++",
    \ "Renamed"   : "?",
    \ "Unmerged"  : "?",
    \ "Deleted"   : "--",
    \ "Dirty"     : "?",
    \ "Clean"     : "?",
    \ "Ignored"   : "?",
    \ "Unknown"   : "?"
    \ }

" change autopairs hotkey to not conflict with commenter
let g:AutoPairsShortcutToggle = '<leader>cfd' " this is just a random hotkey I'll never press

" set terminal size
let g:neoterm_size = 10
" auto open terminal in insert mode
let g:neoterm_autoinsert = 1
" how terminal should open
let g:neoterm_default_mod = 'botright'
" scroll to the end automatically
let g:neoterm_autoscroll = 1

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" language syntax settings
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

" html auto closing on these file types
let g:closetag_filenames = '*.html,*.xhtml,*.xml,*.js,*.html.erb,*.md'
" enter between html tags produces newline and tab
let g:user_emmet_settings = {
\   'html': {
\     'quote_char': '"' 
\   },
\   'javascript': {
\     'quote_char': "'"
\   }
\ }

" TAB to use emmet on html snippets when applicable

let s:emmetActivator = "\<Tab>"
autocmd BufRead,BufNewFile *.html,*.js,*.jsx,*.ts,*.tsx let s:emmetActivator = "\<C-x>\<C-e>"

" lorem TAB and
" lorem# TAB produces lorem ipsum filler content

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" autocomplete
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" don't give |ins-completion-menu| messages.
set shortmess+=c

" TAB autocompletion with emmet

let g:user_emmet_leader_key = '<C-e>'
let g:user_emmet_expandabbr_key = '<C-x><C-e>'
imap <silent><expr> <Tab> <SID>expand()

function! s:expand()
  if pumvisible()
    return "\<C-y>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col - 1]  =~# '\s'
    return "\<Tab>"
  endif
  return s:emmetActivator
endfunction

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" session management
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

fu! SaveSession()
  " close all terminal buffers  
  for b in range(1, bufnr('$'))
    if getbufvar(b, '&buftype', 'ERROR') ==# 'terminal' | execute 'bd!' . b | endif
  endfor
  
  " make directories
  execute 'silent !mkdir -p ~/.nvim'
  execute 'silent !mkdir -p ' . getcwd() . '/.nvim'

  execute 'mksession! ' . getcwd() . '/.nvim/session'
  execute 'mksession! ~/.nvim/session'
endfunction

fu! RestoreBuff(lastBuf)
  if bufexists(1)
    for l in range(1, a:lastBuf)
      if bufwinnr(l) == -1
        exec 'sbuffer ' . l
      endif
    endfor
  endif
endfunction

fu! RestoreSession()
  " only restore if called with no arguments
  if eval('@%') == ''
    " if current directory session exists
    if filereadable(getcwd() . '/.nvim/session')
      execute 'so ' . getcwd() . '/.nvim/session'
        call RestoreBuff(bufnr('$'))
    " if latest session exists
    elseif filereadable('~/.nvim/session')
      execute 'so ~/.nvim/session'
        call RestoreBuff(bufnr('$'))
    endif
  endif
endfunction

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" terminal management
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

let s:termState = 0

fu! Ttoggle()
  if s:termState == 0     " terminal is not open
    let s:termBuffNr = -1
    for b in range(1, bufnr('$'))
      if getbufvar(b, '&buftype', 'ERROR') ==# 'terminal'
        let s:termBuffNr = b
        break
      endif
    endfor

    belowright split
    resize 10

    if s:termBuffNr >= 0  " if terminal buffer already exists
      execute 'b' . s:termBuffNr
    else
      enew
      call termopen('bash', {'on_exit': 'TExit'})
    endif

    startinsert
  else                    " terminal is open
    normal <C-v><C-\><C-n>
    hide
  endif
  let s:termState = ! s:termState
endfunction

fu! TExit(job_id, code, event) dict
  let s:termState = 0
  if winnr('$') ==# 1 | qa! | else | close | endif
endfun

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" basic settings
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

" disable swap file creation due to manual session saving
set noswapfile

" line numbering
set number

" only search by case when using capital letters
set ignorecase
set smartcase

" turn magic on for regex
set magic

" show matching brackets
set showmatch

" blink cursor x tenths of a seconds
set mat=2

" use spaces instead of tabs
set expandtab

" one tab is x many spaces
set shiftwidth=2
set tabstop=2

" x number of lines to see above and below cursor at all times
set scrolloff=5

" enable for various plugin compatibility
set nocompatible

" enable incremental search (search highlights while typing)
set incsearch
set hlsearch

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" gui display
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

" color scheme
set termguicolors
set background=dark
let g:edge_style = 'neon'
colorscheme edge

let s:screenLine = line("w0")
fu! RedrawScreen()
  if s:screenLine != line("w0") | let s:screenLine = line("w0") | redraw! | endif
endfunction

" redraw screen when vertical position has changed 
if has ("windows")
  au CursorMoved,CursorMovedI,VimResized,FocusGained * call RedrawScreen()
  set mousetime=30
  noremap <ScrollWheelUp> <ScrollWheelUp>:call RedrawScreen()<CR>
  noremap <ScrollWheelDown> <ScrollWheelDown>:call RedrawScreen()<CR>
endif

" window title
set title
auto BufEnter * let &titlestring = expand('%:t') . " - " . getcwd()

" highlight line cursor rests on
set cursorline

" mouse support
set mouse=a

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" keyboard shortcuts
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

" fast navigation
" SHIFT + h
" SHIFT + l
" SHIFT + j
" SHIFT + k

nnoremap <S-h> b
vnoremap <S-h> b

nnoremap <S-l> w
vnoremap <S-l> w

nnoremap <S-j> <S-Down>
vnoremap <S-j> <S-Down>

nnoremap <S-k> <S-Up>
vnoremap <S-k> <S-Up>

" tab navigation
" ALT + t opens a new tab
" ALT + w closes the current tab
" ALT + <Right> and
" ALT + <Left> switch tabs
" ALT + h or
" ALT + l alternate mappings
" ALT + e switch/split windows
" :new opens tabs vertically

inoremap <silent> <M-t> <Esc>:enew<CR>i
nnoremap <silent> <M-t> :enew<CR> 
vnoremap <silent> <M-t> :enew<CR> 

" TODO fix session restoring deleted buffers
" TODO call closes extra window if applicable
" command -nargs=? -bang BW :silent! argd % | bw<bang><args>
fu! DelBuff() " deleting buffers
  call SwBuff(-1)
  " seems like buffwinnr is inverted
  if bufwinnr(expand('#:p')) <= 0 && expand('#:p') != expand('%:p')
    if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
      execute 'bw#'
    endif
  endif
endfunction

fu! SwBuff(dir) " switching buffers
  let l:max = bufnr('$')
  let l:n = bufnr('%')

  if &buftype ==# 'terminal' | return | endif

  if a:dir > 0 | let l:n = l:n + 1 | else | let l:n = l:n - 1 | endif

  if l:n > l:max | let l:n = 1 | endif
  if l:n < 1 | let l:n = l:max | endif

  while getbufvar(l:n, '&buftype', 'ERROR') ==# 'nofile' 
        \ || getbufvar(l:n, '&buftype', 'ERROR') ==# 'terminal' 
        \ || !bufexists(l:n)

    if a:dir > 0 | let l:n = l:n + 1 | else | let l:n = l:n - 1 | endif
    if l:n > l:max | let l:n = 1 | endif
    if l:n < 1 | let l:n = l:max | endif
  endwhile

  execute 'b' . l:n
endfunction

inoremap <silent> <M-w> <Esc>:call DelBuff()<CR>i
nnoremap <silent> <M-w> :call DelBuff()<CR>
vnoremap <silent> <M-w> :call DelBuff()<CR>

for i in ['l', 'Right']
  execute 'inoremap <silent> <M-' . i . '> <Esc>:call SwBuff(1)<CR>i'
  execute 'nnoremap <silent> <M-' . i . '> :call SwBuff(1)<CR>'
  execute 'vnoremap <silent> <M-' . i . '> :call SwBuff(1)<CR>'
endfor

for i in ['h', 'Left']
  execute 'inoremap <silent> <M-' . i . '> <Esc>:call SwBuff(-1)<CR>i'
  execute 'nnoremap <silent> <M-' . i . '> :call SwBuff(-1)<CR>'
  execute 'vnoremap <silent> <M-' . i . '> :call SwBuff(-1)<CR>'
endfor

" always split windows vertically
cabbrev new vsplit
set splitright

nnoremap <M-e> <C-w>
vnoremap <M-e> <C-w>

" ALT + <Up>
" ALT + k
" ALT + <Down> 
" ALT + j to scroll faster vertically

let scAmt = 5
for i in ['Up', 'k', 'Down', 'j']
  let key = i
  if i ==# 'Up' || i ==# 'Down'
    let key = '<' . key . '>'
  endif

  let insertScroll = ''
  let c = 0

  while c <= scAmt
    let insertScroll = insertScroll . key
    let c += 1
  endwhile

  execute 'inoremap <silent> <M-' . i . '> <Esc>' . insertScroll . 'i'
  execute 'nnoremap <silent> <M-' . i . '> ' . scAmt . key
  execute 'vnoremap <silent> <M-' . i . '> ' . scAmt . key
endfor

" ALT + p to activame fuzzy finder
" CTRL + p is the default

inoremap <silent> <M-p> <Esc>:CtrlP<CR>
nnoremap <silent> <M-p> :CtrlP<CR>
vnoremap <silent> <M-p> <Esc>:CtrlP<CR>

" CTRL + <Up> or
" CTRL + <Down> to line swap
" CTRL + k or
" CTRL + j alternate mappings

for i in ['Up', 'k']
  execute "inoremap <silent> <C-" . i . "> <Esc>:m .-2<CR>==gi"
  execute "nnoremap <silent> <C-" . i . "> :m .-2<CR>=="
  execute "vnoremap <silent> <C-" . i . "> :m '<-2<CR>gv=gv"
endfor

for i in ['Down', 'j']
  execute "inoremap <silent> <C-" . i . "> <Esc>:m .+1<CR>==gi"
  execute "nnoremap <silent> <C-" . i . "> :m .+1<CR>=="
  execute "vnoremap <silent> <C-" . i . "> :m '>+1<CR>gv=gv"
endfor

" ALT + b toggles the file explorer
" ALT + h toggle displaying hidden files

map <M-b> :NERDTreeToggle<CR>
let NERDTreeMapToggleHidden='<M-h>'

" ALT + / to comment/uncomment line(s) (will not work with non-recursive mappings)

imap <M-/> <Esc>gc<Right><Right>i
nmap <M-/> gc<Right>
vmap <M-/> gc<Right>

" TAB to indent
" SHIFT + TAB to unindent

nnoremap <Tab> >>
vnoremap <Tab> >gv

inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<
vnoremap <S-Tab> <gv

" ALT + f to search
" ESC + ESC to remove highlight
" F3 to skip to next search
" SHIFT + F3 to skip to the previous search

" pressing Esc will not remove search position
set cpoptions+=x

inoremap <M-f> <Esc>:/
nnoremap <M-f> :/
noremap / :/
vnoremap <M-f> :/

inoremap <Esc><Esc> <Esc>:silent! nohls<CR>i
nnoremap <Esc><Esc> :silent! nohls<CR>
vnoremap <Esc><Esc> :silent! nohls<CR>

inoremap <F3> <Esc>ni
nnoremap <F3> n
vnoremap <F3> n

inoremap <F15> <Esc><S-n>i
nnoremap <F15> <S-n>
vnoremap <F15> <S-n>

" ALT + ` to toggle terminal window

command Ttoggle call Ttoggle()

inoremap <M-`> <C-\><C-n>:Ttoggle<CR>
nnoremap <M-`> :Ttoggle<CR>
vnoremap <M-`> :Ttoggle<CR>
tnoremap <M-`> <C-\><C-n>:Ttoggle<CR>

tnoremap <silent> <Esc> <C-\><C-n>

" CTRL + C or
" CTRL + SHIFT + C to copy

" copy entire line
nnoremap <C-c> <Esc>v<S-v>"+y 
vnoremap <C-c> "+y

" ALT + q to quit
inoremap <M-q> <Esc>:call SaveSession()<CR>:q!<CR>
nnoremap <M-q> <Esc>:call SaveSession()<CR>:q!<CR>
vnoremap <M-q> <Esc>:call SaveSession()<CR>:q!<CR>

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" auto commands (events)
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

" refresh fuzzy finder cache every time a file is saved
autocmd FocusGained  * CtrlPClearCache
autocmd BufWritePost * CtrlPClearCache

" always show gutter (set signcolumn=yes does not work in all use cases)
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

" close file explorer if it is the last window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" prevent comments from continuing to new lines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" saving session
autocmd VimLeavePre * call SaveSession()
autocmd VimEnter * nested call RestoreSession()
