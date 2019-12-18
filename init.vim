" Neovim configuration file created by Sam Bossley
" place in ~/.config/nvim/

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
Plug 'joshdick/onedark.vim'             " color scheme
Plug 'sheerun/vim-polyglot'             " improved syntax highlighting
Plug 'ctrlpvim/ctrlp.vim'               " fuzzy finder
Plug 'scrooloose/nerdtree'              " file explorer
Plug 'Xuyuanp/nerdtree-git-plugin'      " git in file explorer
Plug 'scrooloose/nerdcommenter'         " commenting shortcut
Plug 'jiangmiao/auto-pairs'             " auto pair inserting

" tab indentation

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
      \ [ 'a', 'b', 'c' ],
      \ [ 'x', 'y', 'z' ]
      \ ]
let g:airline_section_c = airline#section#create(['file'])
let g:airline_section_x = airline#section#create(['Ln %l, Col %c'])
let g:airline_section_y = airline#section#create(['filetype'])
let g:airline_section_z = airline#section#create(['ffenc'])
let g:airline_extensions = ['branch', 'tabline']
let g:airline#extensions#tabline#buffers_label = ''
" only show path in tab name if it contains another file with the same name
let g:airline#extensions#tabline#formatter = 'unique_tail'

" disable fugitive mappings
let g:fugitive_no_maps = 1

" git gutter symbols
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '~~'
let g:gitgutter_sign_removed = '--'
" disable gutter keymappings
let g:gitgutter_map_keys = 0
" update gutters every x milliseconds
set updatetime=300

" change color scheme
syntax on
colorscheme onedark
" prevent WSL bgcolor glitch by disabling entirely
if has("windows") | hi Normal ctermbg=0 | endif

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
" override default network explorer
let NERDTreeHijackNetrw = 1
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
let NERDTreeIgnore += ['\.vimsess$[[dir]]', '\~$']
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

" add spaces after comment delimiters
let g:NERDSpaceDelims = 1

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" session management
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

" fu! SaveSession()
" call mkdir(getcwd() . '/.vim', 'p')
" execute 'mksession! ' . getcwd() . '/.vim/session'
" endfunction

" fu! RestoreSession()
" if filereadable(getcwd() . '/.vim/session')
" execute 'so ' . getcwd() . '/.vim/session'
" if bufexists(1)
" for l in range(1, bufnr('$'))
" if bufwinnr(l) == -1
" exec 'sbuffer ' . l
" endif
" endfor
" endif
" endif
" endfunction

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" basic settings
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

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

" window title
set title
auto BufEnter * let &titlestring = expand('%:t') . " - " . getcwd()

" mouse support
set mouse=a

" on quit, prompt about unsaved buffers
" set confirm

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

fu! DelBuff()
  " seems like buffwinnr is inverted
  if bufwinnr(expand('#:p')) <= 0 && expand('#:p') != expand('%:p')
    if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
      execute 'bd#'
    endif
  endif
endfunction

inoremap <silent> <M-w> <Esc>:bp<bar>call DelBuff()<CR>i
nnoremap <silent> <M-w> :bp<bar>call DelBuff()<CR>
vnoremap <silent> <M-w> :bp<bar>call DelBuff()<CR>

for i in ['l', 'Right']
  execute 'inoremap <silent> <M-' . i . '> <Esc>:bn<CR>i'
  execute 'nnoremap <silent> <M-' . i . '> :bn<CR>'
  execute 'vnoremap <silent> <M-' . i . '> :bn<CR>'
endfor

for i in ['h', 'Left']
  execute 'inoremap <silent> <M-' . i . '> <Esc>:bp<CR>i'
  execute 'nnoremap <silent> <M-' . i . '> :bp<CR>'
  execute 'vnoremap <silent> <M-' . i . '> :bp<CR>'
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

inoremap <silent> <C-j> <Esc>:m .+1<CR>==gi
nnoremap <silent> <C-j> :m .+1<CR>==
vnoremap <silent> <C-j> :m '>+1<CR>gv=gv

inoremap <silent> <C-k> <Esc>:m .-2<CR>==gi
nnoremap <silent> <C-k> :m .-2<CR>==
vnoremap <silent> <C-k> :m '<-2<CR>gv=gv

" ALT + b toggles the file explorer
" ALT + h toggle displaying hidden files

map <M-b> :NERDTreeToggle<CR>
let NERDTreeMapToggleHidden='<M-h>'

" CTRL + / to comment/uncomment line(s) (cannot do non-recursive mappings)

imap <C-_> <Esc><leader>c<Space>i
nmap <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>

" ALT + f to search
" ESC + ESC to remove highlight

inoremap <silent> <M-f> <Esc>/
nnoremap <silent> <M-f> /
vnoremap <silent> <M-f> /

inoremap <Esc><Esc> <Esc>:silent! nohls<CR>i
nnoremap <Esc><Esc> :silent! nohls<CR>
vnoremap <Esc><Esc> :silent! nohls<CR>

" CTRL + q to close and save current session
" inoremap <C-q> <Esc>:call SaveSession()<CR>:qa<CR>
" nnoremap <C-q> :call SaveSession()<CR>:qa<CR>
" vnoremap <C-q> :call SaveSession()<CR>:qa<CR>

" CTRL + ` to open terminal in a new tab

" tnoremap <silent> <Esc> <C-\><C-n>
" inoremap <M-`> <Esc>:split<bar>resize 10<bar>terminal<CR>i
" nnoremap <M-`> :split<bar>resize 10<bar>terminal<CR>i
" vnoremap <M-`> :split<bar>resize 10<bar>terminal<CR>i

" ------------------------------------------------------------------------
" -----------------------------------------------------------------------------------------------------------------
" auto commands (events)
" -----------------------------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------

" always show gutter (set signcolumn=yes does not work in all use cases)
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

" open file explorer on startup if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" don't open file explorer if session is being restored
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif
" close file explorer if it is the last window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" prevent comments from continuing to new lines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" autocmd VimLeave * call SaveSession()
" autocmd VimEnter * nested call RestoreSession()

