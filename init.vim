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
  au VimEnter *
    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|   PlugInstall --sync | q
    \| en
augroup end

call plug#begin(g:dataDir . 'plugged')

Plug 'junegunn/fzf'

call plug#end()

" plugin compatibility and stop using vi utilities
set nocompatible

" ------------------------------------------------------------------------------
"  session management
" ------------------------------------------------------------------------------

fu s:session_save()
  " touch session directory
  execute 'silent !mkdir -p ' . s:sessDir
  execute 'mksession! ' . s:sessFile
endf

fu s:session_restore()
  " if session exists
  if filereadable(s:sessFile)
    execute 'so ' . s:sessFile
  en
endf

let s:openedDir = eval('@%') == '' && argc() == 0
let s:dir = trim(execute('pwd'))
let s:sessDir = g:dataDir . 'sessions' . s:dir
let s:sessFile = s:sessDir . '/se'

augroup session_management
  au VimLeavePre * if s:openedDir | call s:session_save() | endif
  au VimEnter * nested if s:openedDir | call s:session_restore() | endif
augroup end

" ------------------------------------------------------------------------------
"  core settings
" ------------------------------------------------------------------------------

" disable swap files
set noswapfile

" disable viminfo creation
set viminfo=""

" ------------------------------------------------------------------------------
"  core mappings/bindings
" ------------------------------------------------------------------------------

" C-h 	=> 	Backspace
" jj 	=> 	Escape
" C-j	=> 	Enter/Return/CR
inoremap jj <Esc>

" ------------------------------------------------------------------------------
"  mouse event support
" ------------------------------------------------------------------------------

set mouse=a

"inoremap <C-LeftMouse> <Esc>:echo "ctrl_click!"<CR>i

" ------------------------------------------------------------------------------
"  fuzzy file finding
" ------------------------------------------------------------------------------

nnoremap <silent> <C-p> :FZF<CR>
