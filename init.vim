" Neovim configuration file created by Sam Bossley
" place in ~/.config/nvim/

" ------------------------------------------------------------------------
" plugins
" ------------------------------------------------------------------------

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'               " basic Vim settings
Plug 'vim-airline/vim-airline'          " airline bar customization
"Plug 'zefei/vim-wintabs'
"Plug 'rbgrouleff/bclose.vim'            " closing a buffer without closing the window
" Plug 'moll/vim-bbye'
"Plug 'tpope/vim-fugitive'               " git branch on airline
"Plug 'morhetz/gruvbox'                  " color scheme
"Plug 'scrooloose/nerdtree'          " file explorer
"Plug 'ctrlpvim/ctrlp.vim'           " fuzzy finding
"Plug 'airblade/vim-gitgutter'       " git gutter
"Plug 'scrooloose/nerdcommenter'     " commenting shortcut
"Plug 'jiangmiao/auto-pairs'         " auto pair inserting

call plug#end()

" ------------------------------------------------------------------------
" plugin settings
" ------------------------------------------------------------------------

" airline bar icons
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.whitespace = ''

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

" buffer tabs
"* configure which mode colors should ctrlp window use (takes effect
"  only if the active airline theme doesn't define ctrlp colors) >
"    let g:airline#extensions#ctrlp#color_template = 'insert' (default)
"      let g:airline#extensions#ctrlp#color_template = 'normal'
"        let g:airline#extensions#ctrlp#color_template = 'visual'
"          let g:airline#extensions#ctrlp#color_template = 'replace'
"          <
"          * configure whether to show the previous and next modes (mru, buffer, etc...)
"          >
"           let g:airline#extensions#ctrlp#show_adjacent_modes = 1

"enable/disable nerdtree's statusline integration >
"  let g:airline#extensions#nerdtree_status = 1
"  <  default: 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffers_label = ''

" show buffer tab numbers
"let g:airline#extensions#tabline#buffer_idx_mode = 1

" only show path in tab name if it contains another file with the same name
let g:airline#extensions#tabline#formatter = 'unique_tail'

let g:wintabs_display = 'none'

" change color scheme
"let g:gruvbox_bold = 1
"let g:gruvbox_italic = 1
"let g:gruvbox_underline = 1
"let g:gruvbox_undercurl = 1
"let g:gruvbox_contrast_dark = 'hard'
"set bg=dark
"colorscheme gruvbox
" prevent bgcolor glitch by disabling the bgcolor entirely
" highlight Normal ctermbg=none
" autocmd VimEnter * hi Normal ctermbg=none

" close editor if file explorer is the only window open
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" open file explorer automatically if no files are specified
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | silent NERDTree | endif
" show hidden files in file explorer by default
" let NERDTreeShowHidden = 0
" close explorer on file open
" let NERDTreeQuitOnOpen = 1
" let file explorer open directory by default
" let NERDTreeChDirMode = 1
" specify which files/folders to ignore
" let NERDTreeIgnore =  ['^.git$', '^node_modules$']
" let NERDTreeIgnore += ['\.vim$[[dir]]', '\~$']
" let NERDTreeIgnore += ['\.d$[[dir]]', '\.o$[[file]]', '\.dat$[[file]]', '\.ini$[[file]]']
" let NERDTreeIgnore += ['\.png$','\.jpg$','\.gif$','\.mp3$','\.flac$', '\.ogg$', '\.mp4$','\.avi$','.webm$','.mkv$','\.pdf$', '\.zip$', '\.tar.gz$', '\.rar$']

" fuzzy finder ignore files/folders
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" always show gutter
" (set signcolumn=yes does not work in all use cases)
" autocmd BufEnter * sign define dummy
" autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
" git gutter symbols
" let g:gitgutter_sign_added = '++'
" let g:gitgutter_sign_modified = '~~'
" let g:gitgutter_sign_removed = '--'
" disable gutter keymappings
" let g:gitgutter_map_keys = 0
" update gutters every x milliseconds
" set updatetime=300

" add spaces after comment delimiters
" let g:NERDSpaceDelims = 1

" ------------------------------------------------------------------------
" session management
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
" basic settings
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

" window title
set title
auto BufEnter * let &titlestring = expand('%:t') . " - " . getcwd()

" mouse support
set mouse=a

" prevent comments from continuing to new lines
" autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" on quit, prompt about unsaved buffers
" set confirm

" ------------------------------------------------------------------------
" keyboard shortcuts
" ------------------------------------------------------------------------
" let mapleader = "-"

" 'tab' navigation using ALT and arrow keys
" ALT + t opens a new tab
" ALT + w closes the current tab
" ALT + <Right> and
" ALT + <Left> switch tabs
" ALT + # switches to specific tab
" ALT + s switch between windows

inoremap <silent> <M-t> <Esc>:enew<CR>i
nnoremap <silent> <M-t> :enew<CR>
vnoremap <silent> <M-t> :enew<CR>

fu! DelBuff()
  if bufloaded(expand('#')) && expand('#:p') != expand('%:p')
    execute 'bd#'
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

"let i = 1
"while i < 10
"  execute 'nnoremap <silent> <M-' . i . '> :b' . i . '<CR>'
"  let i += 1
"endwhile

" CTRL + q to close and save current session
" inoremap <C-q> <Esc>:call SaveSession()<CR>:qa<CR>
" nnoremap <C-q> :call SaveSession()<CR>:qa<CR>
" vnoremap <C-q> :call SaveSession()<CR>:qa<CR>

" CTRL + ` to open terminal in a new tab

" tnoremap <silent> <Esc> <C-\><C-n>
" inoremap <M-`> <Esc>:split<bar>resize 10<bar>terminal<CR>i
" nnoremap <M-`> :split<bar>resize 10<bar>terminal<CR>i
" vnoremap <M-`> :split<bar>resize 10<bar>terminal<CR>i

" SHIFT + <Up> or
" SHIFT + <Down> to scroll faster vertically

" nnoremap <silent> <S-Up> 5<Up>
" nnoremap <silent> <S-Down> 5<Down>
" vnoremap <silent> <S-Up> 5<Up>
" vnoremap <silent> <S-Down> 5<Down>

" ALT + <Up> or
" ALT + <Down> to line swap

" nnoremap <A-j> :m .+1<CR>==
" nnoremap <A-Down> :m .+1<CR>==
" nnoremap <A-k> :m .-2<CR>==
" nnoremap <A-Up> :m .-2<CR>==
" inoremap <A-j> <Esc>:m .+1<CR>==gi
" inoremap <A-Down> <Esc>:m .+1<CR>==gi
" inoremap <A-k> <Esc>:m .-2<CR>==gi
" inoremap <A-Up> <Esc>:m .-2<CR>==gi
" vnoremap <A-j> :m '>+1<CR>gv=gv
" vnoremap <A-Down> :m '>+1<CR>gv=gv
" vnoremap <A-k> :m '<-2<CR>gv=gv
" vnoremap <A-Up> :m '<-2<CR>gv=gv

" CTRL + b toggles the file explorer

" map <C-b> :NERDTreeToggle<CR>

" CTRL + h toggle hidden files in the file explorer

" let NERDTreeMapToggleHidden='<C-h>'

" commenter functions (for some reason vim sees <C-/> as <C-_>)
" CTRL + / to comment/uncomment line(s)

" imap <C-_> <Esc><leader>c<Space>i
" nmap <C-_> <leader>c<Space>
" vmap <C-_> <leader>c<Space>

" CTRL + f to search
"nnoremap <silent> <C-f> /

" ------------------------------------------------------------------------
" auto commands (events)
" ------------------------------------------------------------------------

" on file read/open
"fu! DelBuff()
"  if bufloaded(expand('#')) && expand('#:p') != expand('%:p')
"    execute 'bd#'
"  endif
"endfunction

"fu! NewBuff(b)
"  if ! bufloaded(b)
"    read b
"  endif
"endfunction

"autocmd BufReadCmd -nargs=1 * call NewBuff(<f-args>)
"autocmd BufReadCmd * call NewBuff()
"autocmd BufRead * call NewBuff()

" prevent bgcolor flash glitch
" autocmd VimEnter * hi Normal ctermbg=none

" autocmd VimLeave * call SaveSession()
" autocmd VimEnter * nested call RestoreSession()

" AirlineModeChanged " when mode is changed

