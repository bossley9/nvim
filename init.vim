" neovim configuration

" directory where all cacheable data is stored
let g:dataDir = expand('$XDG_DATA_HOME/nvim/')
" current project directory
let s:dir = trim(execute('pwd'))

" ------------------------------------------------------------------------------
"  plugin declaration
" ------------------------------------------------------------------------------

" autoinstall vim-plug
let s:vimPlugDir = g:dataDir . 'site/autoload/plug.vim'
if empty(glob(s:vimPlugDir))
  exe '!curl -fLo ' . s:vimPlugDir . ' --create-dirs '
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
Plug 'vim-airline/vim-airline'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'dense-analysis/ale'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'

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

  let tpbl=[]
  call map(range(1, tabpagenr('$')), 
    \ 'extend(tpbl, tabpagebuflist(v:val))')
  
  for b in range(1, bufnr('$'))
    " 1. buffer is hidden
    " 2. buffer is terminal
    if (bufexists(b) && index(tpbl, b) == -1) ||
      \ getbufvar(b, '&buftype', 'ERROR') ==# 'terminal'
      silent exe 'bd! ' . b
    en
  endfor

  " touch directory and save session
  exe 'silent !mkdir -p ' . s:sessDir
  exe 'mksession! ' . s:sessFile
endf

fu! s:session_restore()
  " if session exists
  if filereadable(s:sessFile)
    exe 'so ' . s:sessFile
  else
    " file explorer
    NERDTree
  en
endf

let s:openedDir = eval('@%') == '' && argc() == 0
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

" prevent comments from continuing to new lines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" remove file name from the command line bar
set shortmess+=F

" ------------------------------------------------------------------------------
"  core mappings/bindings
" ------------------------------------------------------------------------------

" insert:
" C-h 	=> 	BS
" jj 	  => 	Esc
" C-j	  => 	CR
" visual:
" M-k   =>  Esc
inoremap jj     <Esc>
vnoremap <M-k>  <Esc>
vnoremap <M-j>  <Esc>

" basic buffer navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" basic vertical navigation
nnoremap <M-j> 5j
nnoremap <M-k> 5k

" nohl
nnoremap <Space><Space> :noh<CR>

" reload config and window
nnoremap <C-R> :let winv = winsaveview()<Bar>
  \so $XDG_CONFIG_HOME/nvim/init.vim<Bar>
  \call winrestview(winv)<Bar>
  \unlet winv<CR>

" ------------------------------------------------------------------------------
"  core functions
" ------------------------------------------------------------------------------

" floating window creator
" arguments are (x, y, w, h, bufnr?)
" x, y, w, and h are all [0..1] values
" bufnr? is an optional buffer number of an existing buffer
fu! s:core_functions_create_window(x, y, w, h, ...)
  " create unlisted, scratch buffer
  let b = a:0 > 0 ? a:1 : nvim_create_buf(v:false, v:true)

  let opts = {
    \ 'relative': 'editor',
    \ 'style': 'minimal',
    \ 'col': float2nr(&columns * a:x),
    \ 'row': float2nr(&lines * a:y),
    \ 'width': float2nr(&columns * a:w),
    \ 'height': float2nr(&lines * a:h)
    \ }

  " center param is true if window should be autofocused
  call nvim_open_win(b, v:true, opts)
  return b
endfunction

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

nnoremap <silent> <M-p> <Esc>:FZF<CR>
vnoremap <silent> <M-p> <Esc>:FZF<CR>

" ------------------------------------------------------------------------------
"  file explorer
" ------------------------------------------------------------------------------

" toggle explorer pane
nnoremap <M-b> :NERDTreeToggle<CR>
inoremap <M-b> <Esc>:NERDTreeToggle<CR>
vnoremap <M-b> <Esc>:NERDTreeToggle<CR>
tnoremap <M-b> <Esc>:NERDTreeToggle<CR>

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
" minimal ui
let NERDTreeMinimalUI = 1
" collapse folders if applicable
let NERDTreeCascadeSingleChildDir = 1
" let file explorer open directory by default
let NERDTreeChDirMode = 1
" specify which files/folders to ignore
let NERDTreeIgnore =  ['^.git$', '^node_modules$', '\.vim$[[dir]]', '\~$']
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
let g:gitgutter_sign_added = '▌'
let g:gitgutter_sign_modified = '▌'
let g:gitgutter_sign_removed = '▌'
let g:gitgutter_sign_removed_first_line = '▌'
let g:gitgutter_sign_modified_removed = '▌'

" always display sign column
if has('signcolumn') | set signcolumn=yes | en

augroup vcs_integration
  au!
  " set signcolumn=yes does not work in all use cases
  " place dummy sign to keep gutter open
  au BufEnter * sign define dummy
  au BufEnter * exe 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup end

" ------------------------------------------------------------------------------
"  terminal management
" ------------------------------------------------------------------------------

nnoremap <M-`> :TerminalToggle<CR>
inoremap <M-`> <C-\><C-n>:TerminalToggle<CR>
vnoremap <M-`> :TerminalToggle<CR>
tnoremap <M-`> <C-\><C-n>:TerminalToggle<CR>

com! TerminalToggle call s:terminal_toggle()
let s:termbufnr = -1
let s:termopen = 0
fu! s:terminal_toggle()
  let l:y = 0
  let l:h = 1 - l:y

  " if terminal is open
  if s:termopen

    norm <C-v><C-\><C-n>
    hide
  else

    " if window does not exist
    if s:termbufnr < 0
      let s:termbufnr = s:core_functions_create_window(0, l:y, 1, l:h)
      call termopen('zsh', {'on_exit': 'Terminal_exit'})

    " if terminal is closed
    else
      let s:termbufnr = s:core_functions_create_window(0, l:y, 1, l:h, s:termbufnr)
    en

    exe 'b' . s:termbufnr
    startinsert
  en

  let s:termopen = ! s:termopen
endfunction

fu! Terminal_exit(job_id, code, event) dict
  if winnr('$') ==# 1 | qa! | else | bw! | endif
  let s:termopen = 0
  let s:termbufnr = -1
endfunction

" ------------------------------------------------------------------------------
"  status bar / tabline
" ------------------------------------------------------------------------------

let g:airline#extensions#default#layout = [
  \   [ 'a', 'c' ],
  \   [ 'x', 'y']
  \ ]
let g:airline_section_c = airline#section#create(['file'])
let g:airline_section_x = airline#section#create(['Ln %l, Col %c'])
let g:airline_section_y = airline#section#create(['filetype'])
let g:airline_extensions = ['tabline']
" show project directory in the tabline
let g:airline#extensions#tabline#buffers_label = s:dir
" only show path in tab name if it contains another file with the same name
let g:airline#extensions#tabline#formatter = 'unique_tail'

" ------------------------------------------------------------------------------
"  code folding
" ------------------------------------------------------------------------------

set foldmethod=syntax
" TEMP
set nofoldenable
" set foldenable
set foldnestmax=10
set foldlevelstart=1

let javaScript_fold = 1
let ruby_fold = 1
let sh_fold_enabled = 1

" ------------------------------------------------------------------------------
"  linting/prettier
" ------------------------------------------------------------------------------

let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '!!'
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'typescriptreact': ['prettier']
\}

fu! TogglePrettierOnSave()
  if (g:ale_fix_on_save == 0)
    let g:ale_fix_on_save = 1
  else
    let g:ale_fix_on_save = 0
  en
  exe 'echo "Prettier=' . g:ale_fix_on_save . '"'
endfunction
com TogglePrettier call TogglePrettierOnSave()

" ------------------------------------------------------------------------------
"  commenting/tabbing
" ------------------------------------------------------------------------------

" will not work if nonrecursive
imap <M-/> <Esc>gc<Right><Right>i
nmap <M-/> <Esc>gc<Right>
vmap <M-/> gcgv

nnoremap <Tab> >>
vnoremap <Tab> >gv

inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<
vnoremap <S-Tab> <gv

" ------------------------------------------------------------------------------
"  appearance
" ------------------------------------------------------------------------------

" line numbers
set number

" show matching brackets
set showmatch

" number of lines above and below cursor at all times
set scrolloff=5

so $XDG_CONFIG_HOME/nvim/colors.vim

