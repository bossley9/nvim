" neovim configuration

" ------------------------------------------------------------------------------
"  plugin declaration
" ------------------------------------------------------------------------------

" autoinstall vim-plug and plugins
let s:vimPlugDir = expand('$XDG_DATA_HOME/nvim/site/autoload/plug.vim')
if empty(glob(s:vimPlugDir))
  execute 'silent !curl -fLo ' . s:vimPlugDir . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')

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
let s:sessDir = expand('$XDG_CACHE_HOME/nvim') . s:dir
let s:sessFile = s:sessDir . '/se'

augroup session_management
  au!
  au VimLeavePre * if s:openedDir | call SessionSave() | endif
  au VimEnter * nested if s:openedDir | call SessionRestore() | endif
augroup end
