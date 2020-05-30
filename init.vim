" neovim configuration

" directory where all cacheable data is stored
let g:dataDir = expand('$XDG_DATA_HOME/nvim/')

" ------------------------------------------------------------------------------
"  plugin declaration
" ------------------------------------------------------------------------------

" autoinstall vim-plug
let s:vimPlugDir = g:dataDir . 'site/autoload/plug.vim'
if empty(glob(s:vimPlugDir))
  execute '!curl -fLo ' . s:vimPlugDir . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
en

" autoinstall plugins
augroup plugin_management
  au!
  au VimEnter *
    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|   PlugInstall --sync | q
    \| en
augroup end

" plugin list
call plug#begin(g:dataDir . 'plugged')

Plug 'junegunn/fzf'
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end()

" plugin compatibility and stop using vi utilities
set nocompatible
" enable plugins
filetype plugin on

" ------------------------------------------------------------------------------
"  session management
" ------------------------------------------------------------------------------

fu! s:session_save()
  " file explorer
  NERDTreeClose
  " touch session directory
  execute 'silent !mkdir -p ' . s:sessDir
  execute 'mksession! ' . s:sessFile
endf

fu! s:session_restore()
  " if session exists
  if filereadable(s:sessFile)
    execute 'so ' . s:sessFile
  else
    " file explorer
    NERDTree
  en
endf

let s:openedDir = eval('@%') == '' && argc() == 0
let s:dir = trim(execute('pwd'))
let s:sessDir = g:dataDir . 'sessions' . s:dir
let s:sessFile = s:sessDir . '/se'

augroup session_management
  au!
  au VimLeavePre * if s:openedDir 
    \ | call s:session_save() | endif
  au VimEnter * nested if s:openedDir 
    \ | call s:session_restore() | endif
augroup end

" ------------------------------------------------------------------------------
"  core settings
" ------------------------------------------------------------------------------

" disable swap files
set noswapfile

" disable viminfo creation
set viminfo=""

" only search by case when using capital letters
set ignorecase
set smartcase

" search highlight while typing
set incsearch
set hlsearch

" turn magic on for regex
set magic

" indent tab width
filetype plugin indent on
let s:indent = 2
let &tabstop=s:indent
let &softtabstop=s:indent
let &shiftwidth=s:indent
" use spaces instead of tabs
set expandtab

" code folding
set foldmethod=syntax
set foldenable
set foldnestmax=10
set foldlevelstart=1

let javaScript_fold=1
let ruby_fold=1
let sh_fold_enabled=1

" ------------------------------------------------------------------------------
"  core mappings/bindings
" ------------------------------------------------------------------------------

" insert:
" C-h 	=> 	BS
" jj 	  => 	Esc
" C-j	  => 	CR
" visual:
" C-k   =>  Esc
inoremap jj     <Esc>
vnoremap <C-k>  <Esc>

" basic buffer navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ------------------------------------------------------------------------------
"  mouse events
" ------------------------------------------------------------------------------

set mouse=a

"augroup mouse_events
"  au!
"  au CursorHold * echo expand("<cword>")
"  au CursorHoldI * echo expand("<cword>")
"augroup end

" ------------------------------------------------------------------------------
"  fuzzy file finding
" ------------------------------------------------------------------------------

nnoremap <silent> <C-p> :FZF<CR>

" ------------------------------------------------------------------------------
"  file explorer
" ------------------------------------------------------------------------------

" toggle explorer pane
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-E> :NERDTreeToggle<CR>
inoremap <C-b> <Esc>:NERDTreeToggle<CR>
inoremap <C-E> <Esc>:NERDTreeToggle<CR>
vnoremap <C-b> <Esc>:NERDTreeToggle<CR>
vnoremap <C-E> <Esc>:NERDTreeToggle<CR>
tnoremap <C-b> <Esc>:NERDTreeToggle<CR>
tnoremap <C-E> <Esc>:NERDTreeToggle<CR>

" don't show hidden files in file explorer by default
let NERDTreeShowHidden = 0
" close explorer on file open
let NERDTreeQuitOnOpen = 1
" keep file explorer closed on open
" let g:NERDTreeHijackNetrw = 0
" sort numbers like 1, 10, 11, 100, rather than 1, 10, 100, 11
let NERDTreeNaturalSort = 1
" color highlighted entry
let NERDTreeHighlightCursorLine = 1
" set window size
" let NERDTreeWinSize = 25
" single click opens folder, double click opens node
let NERDTreeMouseMode = 2
" minimal ui
let NERDTreeMinimalUI = 1
" collapse folders if applicable
let NERDTreeCascadeSingleChildDir = 1
" let file explorer open directory by default
let NERDTreeChDirMode = 1
" specify which files/folders to ignore
let NERDTreeIgnore =  ['^.git$', '^node_modules$', '\.vim$[[dir]]', '\~$']
"let NERDTreeIgnore += ['\.d$[[dir]]']
"let NERDTreeIgnore += ['\.o$[[file]]','\.dat$[[file]]','\.ini$[[file]]']
"let NERDTreeIgnore += ['\.png$','\.jpg$','\.gif$']
"let NERDTreeIgnore += ['\.mp3$','\.flac$','\.ogg$']
"let NERDTreeIgnore += ['\.mp4$','\.avi$','.webm$','.mkv$']
"let NERDTreeIgnore += ['\.pdf$']
"let NERDTreeIgnore += ['\.zip$','\.tar.gz$','\.rar$']
" show hidden files
let NERDTreeShowHidden = 1

augroup file_explorer
  au!
  " close editor if only file explorer is open
  au BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") 
    \ && b:NERDTree.isTabTree()) | q | en
augroup end

" TODO https://github.com/preservim/nerdtree/issues/433#issuecomment-92590696

" ------------------------------------------------------------------------------
"  vcs integration
" ------------------------------------------------------------------------------

" disable gutter keymappings
let g:gitgutter_map_keys = 0
" update gutters every x milliseconds
set updatetime=300
" git gutter symbols
let g:gitgutter_sign_added = '++'
let g:gitgutter_sign_modified = '~~'
let g:gitgutter_sign_removed = '--'

" always display sign column
if has('signcolumn') | set signcolumn=yes | en

augroup vcs_integration
  au!
  " set signcolumn=yes does not work in all use cases
  " place dummy sign to keep gutter open
  au BufEnter * sign define dummy
  au BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup end

" ------------------------------------------------------------------------------
"  terminal management
" ------------------------------------------------------------------------------

command Ttoggle call Ttoggle()

inoremap <M-`> <C-\><C-n>:Ttoggle<CR>
nnoremap <M-`> :Ttoggle<CR>
vnoremap <M-`> :Ttoggle<CR>
tnoremap <M-`> <C-\><C-n>:Ttoggle<CR>

tnoremap <silent> <Esc> <C-\><C-n>

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
      call termopen('zsh', {'on_exit': 'TExit'})
    endif

    set nonumber
    set norelativenumber
    set signcolumn=no
    set nocursorline

    startinsert
  else                    
  " terminal is open
    normal <C-v><C-\><C-n>
    hide
  endif
  let s:termState = ! s:termState
endfunction

fu! TExit(job_id, code, event) dict
  let s:termState = 0
  if winnr('$') ==# 1 | qa! | else | bw! | endif
endfunction

" ------------------------------------------------------------------------------
"  appearance
" ------------------------------------------------------------------------------

" line numbers
set number

" show matching brackets
set showmatch

" number of lines above and below cursor at all times
set scrolloff=5
