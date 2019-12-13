" Neovim configuration file created by Sam Bossley
" place in ~/.config/nvim/

" ------------------------------------------------------------------------
" starting from a clean slate
" ------------------------------------------------------------------------

" The steps in this section assume that you do not have Neovim, Vim Plug,
" or any other plugins installed.

" First, install Neovim:
" $ sudo apt-get install neovim

" Next, install Vim Plug for plugin support:
" $ curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" To install Vim Plug plugins, open Neovim using the following command:
" $ nvim
" Then install plugins:
" $ :PlugInstall
" You will likely have to restart Neovim for changes to take effect.

" ------------------------------------------------------------------------
" plugins
" ------------------------------------------------------------------------

" start of plugins
call plug#begin('~/.vim/plugged')

" basic Vim settings
Plug 'tpope/vim-sensible'

" bar customization
Plug 'vim-airline/vim-airline'

" closing a buffer without closing the window
Plug 'rbgrouleff/bclose.vim'

" color scheme
Plug 'morhetz/gruvbox'

" file explorer
Plug 'scrooloose/nerdtree'

" fuzzy finding
Plug 'ctrlpvim/ctrlp.vim'

" git gutter
Plug 'airblade/vim-gitgutter'

" commenting shortcut
Plug 'scrooloose/nerdcommenter'

" auto pair inserting
Plug 'jiangmiao/auto-pairs'

" initialize all plugins
call plug#end()

" ------------------------------------------------------------------------
" plugin settings
" ------------------------------------------------------------------------

" setup tabline
let g:airline#extensions#tabline#enabled = 1
" differentiate current tab from others
let g:airline#extensions#tabline#alt_sep = 1

" change color scheme
let g:gruvbox_bold = 1
let g:gruvbox_italic = 1
let g:gruvbox_underline = 1
let g:gruvbox_undercurl = 1
let g:gruvbox_contrast_dark = 'hard'
set bg=dark
colorscheme gruvbox
" prevent bgcolor glitch by disabling the bgcolor entirely
highlight Normal ctermbg=none
autocmd VimEnter * hi Normal ctermbg=none

" close editor if file explorer is the only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" open file explorer automatically if no files are specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | silent NERDTree | endif
" show hidden files in file explorer by default
let NERDTreeShowHidden = 0
" close explorer on file open
let NERDTreeQuitOnOpen = 1
" let file explorer open directory by default
let NERDTreeChDirMode = 1
" specify which files/folders to ignore
let NERDTreeIgnore =  ['^.git$', '^node_modules$']
let NERDTreeIgnore += ['\.vim$[[dir]]', '\~$']
let NERDTreeIgnore += ['\.d$[[dir]]', '\.o$[[file]]', '\.dat$[[file]]', '\.ini$[[file]]']
let NERDTreeIgnore += ['\.png$','\.jpg$','\.gif$','\.mp3$','\.flac$', '\.ogg$', '\.mp4$','\.avi$','.webm$','.mkv$','\.pdf$', '\.zip$', '\.tar.gz$', '\.rar$']

" fuzzy finder ignore files/folders
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" always show gutter
set signcolumn=yes
" git gutter symbols
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '~~'
let g:gitgutter_sign_removed = '--'
" disable gutter keymappings
let g:gitgutter_map_keys = 0
" update gutters every x milliseconds
set updatetime=300

" add spaces after comment delimiters
let g:NERDSpaceDelims = 1

" ------------------------------------------------------------------------
" keyboard shortcuts
" ------------------------------------------------------------------------
let mapleader = "-"

" CTRL + q to close and save current session
inoremap <C-q> <Esc>:call SaveSession()<CR>:qa<CR>
nnoremap <C-q> :call SaveSession()<CR>:qa<CR>
vnoremap <C-q> :call SaveSession()<CR>:qa<CR>

" CTRL + ` to open terminal in a new tab

tnoremap <silent> <Esc> <C-\><C-n>
inoremap <M-`> <Esc>:split<bar>resize 10<bar>terminal<CR>i
nnoremap <M-`> :split<bar>resize 10<bar>terminal<CR>i
vnoremap <M-`> :split<bar>resize 10<bar>terminal<CR>i

" SHIFT + <Up> or
" SHIFT + <Down> to scroll faster vertically

nnoremap <silent> <S-Up> 5<Up>
nnoremap <silent> <S-Down> 5<Down>
vnoremap <silent> <S-Up> 5<Up>
vnoremap <silent> <S-Down> 5<Down>

" ALT + <Up> or
" ALT + <Down> to line swap

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-Down> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
vnoremap <A-Up> :m '<-2<CR>gv=gv

" CTRL + b toggles the file explorer

map <C-b> :NERDTreeToggle<CR>

" CTRL + h toggle hidden files in the file explorer 

let NERDTreeMapToggleHidden='<C-h>'

" commenter functions (for some reason vim sees <C-/> as <C-_>)
" CTRL + / to comment/uncomment line(s)

imap <C-_> <Esc><leader>c<Space>i
nmap <C-_> <leader>c<Space>
vmap <C-_> <leader>c<Space>

" 'tab' navigation using ALT and arrow keys
" ALT + t opens a new tab
" ALT + w closes the current tab
" ALT + <Right> and
" ALT + <Left> switch tabs 

inoremap <M-t> <Esc>:enew<CR>i
nnoremap <M-t> <Esc>:enew<CR>
vnoremap <M-t> <Esc>:enew<CR>

inoremap <M-w> <Esc>:bp<bar>sp<bar>bn<bar>bd<CR>i
nnoremap <M-w> <Esc>:bp<bar>sp<bar>bn<bar>bd<CR>
vnoremap <M-w> <Esc>:bp<bar>sp<bar>bn<bar>bd<CR>

imap <M-l> <Esc>:bn<CR>i
imap <M-Right> <Esc>:bn<CR>i
nmap <M-l> :bn<CR>
nmap <M-Right> :bn<CR>
vmap <M-l> :bn<CR>
vmap <M-Right> :bn<CR>

imap <M-h> <Esc>:bp<CR>i
imap <M-Left> <Esc>:bp<CR>i
nmap <M-h> :bp<CR>
nmap <M-Left> :bp<CR>
vmap <M-h> :bp<CR>
vmap <M-Left> :bp<CR>

" ------------------------------------------------------------------------
" session management
" ------------------------------------------------------------------------

fu! SaveSession()
  call mkdir(getcwd() . '/.vim', 'p') 
  execute 'mksession! ' . getcwd() . '/.vim/session'
endfunction

fu! RestoreSession()
  if filereadable(getcwd() . '/.vim/session')
    execute 'so ' . getcwd() . '/.vim/session'
    " if bufexists(1)
      " for l in range(1, bufnr('$'))
        " if bufwinnr(l) == -1
          " exec 'sbuffer ' . l
        " endif
      " endfor
    " endif
  endif
endfunction

"autocmd VimLeavePre * call SaveSession()
autocmd VimEnter * nested call RestoreSession()

" ------------------------------------------------------------------------
" basic settings
" ------------------------------------------------------------------------

" scrollback history
set history=1000

" enable filetype plugins
filetype plugin on " needed for nerdcommenter to work
filetype indent on

" autoread when a file is changed from the outside
set autoread

" show current position
set ruler

" ignore case when searching and be smart about it
set ignorecase
set smartcase

" highlight search
set hlsearch
set incsearch

" turn magic on for regex
set magic

" show matching brackets
set showmatch

" blink cursor this many tenths of a seconds
set mat=2

" use spaces instead of tabs and be smart
set expandtab
set smarttab

" one tab is this many spaces
set shiftwidth=2
set tabstop=2

" linebreak at 500 characters
set lbr
set tw=500

" line numbering
set number

" number of lines to see above and below cursor at all times 
set scrolloff=5

" key compatibility with remote shells and such
set nocompatible

" mouse support
set mouse=a

" prevent comments from continuing to new lines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" on quit, prompt about unsaved buffers
set confirm
