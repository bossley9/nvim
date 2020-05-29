" neovim configuration

" directory where all cacheable data is stored
let g:dataDir = expand('$XDG_DATA_HOME/nvim/')

" ------------------------------------------------------------------------------
"  plugin declaration
" ------------------------------------------------------------------------------

" autoinstall vim-plug
let s:vimPlugDir = g:dataDir . 'site/autoload/plug.vim'
if empty(glob(s:vimPlugDir))
  execute 'silent !curl -fLo ' . s:vimPlugDir . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" autoinstall plugins
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

call plug#begin(g:dataDir . 'plugged')

call plug#end()

" ------------------------------------------------------------------------------
"  session management
" ------------------------------------------------------------------------------

fu! SessionSave()
  " touch session directory
  execute 'silent !mkdir -p ' . s:sessDir
  execute 'mksession! ' . s:sessFile
endfunction

fu! SessionRestore()
  " if session exists
  if filereadable(s:sessFile)
    execute 'so ' . s:sessFile
  endif
endfunction

let s:openedDir = eval('@%') == ''
let s:dir = trim(execute('pwd'))
let s:sessDir = g:dataDir . 'sessions' . s:dir
let s:sessFile = s:sessDir . '/se'

augroup session_management
  au!
  au VimLeavePre * if s:openedDir | call SessionSave() | endif
  au VimEnter * nested if s:openedDir | call SessionRestore() | endif
augroup end
