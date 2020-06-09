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
Plug 'APZelos/blamer.nvim'
Plug 'tpope/vim-surround'

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
    " TODO 1. buffer is hidden
      " \ (bufexists(b) && index(tpbl, b) == -1) ||
    " 2. buffer is terminal
    if (
      \ getbufvar(b, '&buftype', 'ERROR') ==# 'terminal'
      \ )
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
" set magic

" indent tab width
filetype plugin indent on
let s:indent = 2
let &tabstop=s:indent
let &softtabstop=s:indent
let &shiftwidth=s:indent
" use spaces instead of tabs
set expandtab

" prevent comments from continuing to new lines
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

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
" M-h   =>  Esc
" M-l   =>  Esc
inoremap jj     <Esc>
vnoremap <M-h>  <Esc>
vnoremap <M-l>  <Esc>

" basic buffer navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" basic vertical navigation
nnoremap <M-j> 5j
nnoremap <M-k> 5k

" basic visual navigation
vnoremap <M-j> 5j
vnoremap <M-k> 5k

" nohl
nnoremap <Space> :noh<CR>

" reload config and window
nnoremap <M-r> :let winv = winsaveview()<Bar>
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

" ------------------------------------------------------------------------------
"  clipboard
" ------------------------------------------------------------------------------

" c-c and c-s-v for terminal compatibility
vnoremap <C-c> "+ygv

" ------------------------------------------------------------------------------
"  vcs integration
" ------------------------------------------------------------------------------

let s:vcs = '▌'

" disable gutter keymappings
let g:gitgutter_map_keys = 0
" update gutters every x milliseconds
set updatetime=300
" git gutter symbols
let g:gitgutter_sign_added = s:vcs
let g:gitgutter_sign_modified = s:vcs
let g:gitgutter_sign_removed = s:vcs
let g:gitgutter_sign_removed_first_line = s:vcs
let g:gitgutter_sign_modified_removed = s:vcs

" always display sign column
if has('signcolumn') | set signcolumn=yes | en

let g:NERDTreeIndicatorMapCustom = {
  \ "Modified"  : ' ',
  \ "Staged"    : ' ',
  \ "Untracked" : ' ',
  \ "Renamed"   : ' ',
  \ "Unmerged"  : ' ',
  \ "Deleted"   : ' ',
  \ "Dirty"     : ' ',
  \ "Clean"     : ' ',
  \ 'Ignored'   : ' ',
  \ "Unknown"   : ' '
  \ }

augroup vcs_integration
  au!
  " set signcolumn=yes does not work in all use cases
  " place dummy sign to keep gutter open
  au BufEnter * sign define dummy
  au BufEnter * exe 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
augroup end

let g:blamer_enabled = 1
let g:blamer_delay = 1500
let g:blamer_template = '<committer> <committer-time> • <summary>'
let g:blamer_date_format = '%Y.%m.%d %H:%M'

" ------------------------------------------------------------------------------
"  terminal management
" ------------------------------------------------------------------------------

" total num of terminal bufs available
let s:num_total_term_bufs = 4

for m in ['n', 'i', 'v', 't']
  exe m.'noremap <M-`> <C-\><C-n>:TerminalToggle<CR>'
endfor

" terminal buffer list
let s:termbl = []

for i in range(s:num_total_term_bufs)
  call add(s:termbl, -1)
  let n = i + 1 
  exe 'tnoremap <M-'.n.'> <C-\><C-n>:TerminalFocus '.n.'<CR>' 
endfor

" terminal buffer list index
let s:termbli = -1
" is terminal window open
let s:istermo = 0

fu! s:terminal_open_window(...)
  let l:y = 0
  let l:h = 1 - l:y
  let l:b = -1

  if a:0 > 0 && a:1 >= 0 " open existing buffer
    let l:b = s:core_functions_create_window(0, l:y, 1, l:h, a:1)
    
  else " create new buffer
    let l:b = s:core_functions_create_window(0, l:y, 1, l:h)
    call termopen('zsh', {'on_exit': 'Terminal_exit'})
  en

  exe 'b' . l:b
  startinsert
  return l:b
endfunction

com! TerminalToggle call s:terminal_toggle()
fu! s:terminal_toggle()
  " if terminal is open
  if s:istermo
    norm <C-v><C-\><C-n>
    hide
  else

    " if window does not exist
    if s:termbli < 0 | let s:termbli = 0 | en
    let s:termbl[s:termbli] = 
      \s:terminal_open_window(s:termbl[s:termbli])
  en

  let s:istermo = ! s:istermo
endfunction

com! -nargs=1 TerminalFocus 
  \call s:terminal_focus(<f-args>)
fu! s:terminal_focus(index)
  let s:termbli = a:index - 1
  norm <C-v><C-\><C-n>
  let l:prev = bufnr('%')
  hide

  let s:termbl[s:termbli] = 
    \s:terminal_open_window(s:termbl[s:termbli])
endfunction

fu! Terminal_exit(job_id, code, event) dict
  bw!
  let s:istermo = 0
  let s:termbl[s:termbli] = -1
  let s:termbli = 0
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
com! TogglePrettier call TogglePrettierOnSave()

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
"  matching paren
" ------------------------------------------------------------------------------

" TODO testing
inoremap (; (<CR>);<C-c>O
inoremap (, (<CR>),<C-c>O
inoremap {; {<CR>};<C-c>O
inoremap {, {<CR>},<C-c>O
inoremap [; [<CR>];<C-c>O
inoremap [, [<CR>],<C-c>O

" ------------------------------------------------------------------------------
"  file/project search
" ------------------------------------------------------------------------------

" nnoremap <M-f> <Esc>:ToggleFSearch<CR>

" let s:isfsearch = 0
" 
" com! ToggleFSearch call s:toggle_file_search()
" fu! s:toggle_file_search()
"   if s:isfsearch == 0 " closed
"     " open it
"     let l:fswin = s:core_functions_create_window(0, 0, 0.5, 0.1)
"   else
"     " close it
"   en
" 
"   let s:isfsearch = ! s:isfsearch
" endfunction

" TODO visual select permutate all lines
" vnoremap I 

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

" TODO emmet?
" TODO https://github.com/ryanoasis/vim-devicons
