" neovim configuration

" ------------------------------------------------------------------------------
"  plugins
" ------------------------------------------------------------------------------

call plug#begin('$XDG_CONFIG_HOME/nvim/plugged')

call plug#end()

" automatically install plugins
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
