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
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'
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

  call s:clear_buffers()

  " touch directory and save session
  exe 'silent !mkdir -p ' . s:sessDir
  exe 'mksession! ' . s:sessFile
endf

fu! s:session_restore()
  " tags
  GenTags
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

" hide mode from displaying in command line bar
set noshowmode

" ------------------------------------------------------------------------------
"  core mappings/bindings
" ------------------------------------------------------------------------------

let s:nav_jump = 5

" no help docs!
nnoremap K k

" no double taps
" I know it blocks the default binding, used for useful stuff like
" yiw and yaw, but I rarely want to copy words. I'd rather use
" diw and daw for such things
" nnoremap y yy

" <C-g> to view path

" line ends
nnoremap ! 0
nnoremap @ $

" <CR>, <Esc>, <BS> basics
inoremap <M-h> <BS>
inoremap <M-;> <Esc>
inoremap <M-j> <CR>

vnoremap <M-;> <Esc>

" legacy
" inoremap jj <Esc> 

" basic buffer navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <M-h> <C-w>h
nnoremap <M-l> <C-w>l

" basic vertical navigation
exe 'nnoremap <M-j> ' . s:nav_jump . 'j'
exe 'nnoremap <M-k> ' . s:nav_jump . 'k'
exe 'vnoremap <M-j> ' . s:nav_jump . 'j'
exe 'vnoremap <M-k> ' . s:nav_jump . 'k'

nnoremap <M-u> <C-u>
nnoremap <M-d> <C-d>

" nohl
nnoremap <Space> :noh<CR>

" reload config and window
nnoremap <silent> <M-r> :let winv = winsaveview()<Bar>
  \so $XDG_CONFIG_HOME/nvim/init.vim<Bar>
  \call winrestview(winv)<Bar>
  \unlet winv<CR>
  \:Clear<CR>
  \:NERDTreeRefreshRoot<CR>
  \:GenTags<CR>

" closing and saving
nnoremap ZZ :wqa<CR>
nnoremap ZQ :qa!<CR>

" to prevent annoying modals and errors
" from mistyping and clumsiness
com! W norm :w<CR>

" permutate insert... because I 
" seem to use this all the time...
vnoremap I 0<C-v>I
vnoremap A $<C-v>A

" ------------------------------------------------------------------------------
"  core functions - windows
" ------------------------------------------------------------------------------

" floating window creator
" arguments are (x, y, w, h, windowObj?)
" x, y, w, and h are all [0..1] values
" windowObj? is an optional windowObj which already exists

" wrapper - when called with the above arguments, will return a
" preview window object and display the window
fu! g:Win_New(x, y, w, h)
  return s:core_window_create(a:x, a:y, a:w, a:h)
endfunction

" wrapper - when called with a preview window object, will hide 
" or show the preview window
fu! g:Win_Toggle(windowobj)
  return s:core_window_toggle(a:windowobj)
endfunction

fu! s:core_window_create(x, y, w, h, ...)
  " fg represents foreground and
  " bg represents background
  let l:fgb = -1

  let l:col = float2nr(&columns * a:x)
  let l:row = float2nr(&lines * a:y)
  let l:width = float2nr(&columns * a:w)
  let l:height = float2nr(&lines * a:h)

  try
    let l:fgb = a:0 > 0 && a:1.fgb >= 0
      \ ? a:1.fgb
      \ : nvim_create_buf(v:false, v:true)
  catch
  endtry

  let l:bgb = nvim_create_buf(v:false, v:true)
  " write border lines
  let l:top = "╭" . repeat("─", l:width + 2) . "╮"
  let l:mid = "│" . repeat(" ", l:width + 2) . "│"
  let l:bot = "╰" . repeat("─", l:width + 2) . "╯"
  let l:lines = [l:top] + repeat([l:mid], l:height) + [l:bot]
  call nvim_buf_set_lines(l:bgb, 0, -1, v:true, l:lines)

  let bopts = {
    \ 'relative': 'editor',
    \ 'style': 'minimal',
    \ 'row': l:row - 1,
    \ 'col': l:col - 2,
    \ 'width': l:width + 4,
    \ 'height': l:height + 2
    \ }

  let opts = {
    \ 'relative': 'editor',
    \ 'style': 'minimal',
    \ 'col': l:col,
    \ 'row': l:row,
    \ 'width': l:width,
    \ 'height': l:height
    \ }

  let l:bgw = nvim_open_win(l:bgb, v:true, bopts)
  let l:fgw = nvim_open_win(l:fgb, v:true, opts)

  hi WindowBorder ctermfg=Red
  call setwinvar(l:bgw, '&winhl', 'Normal:WindowBorder')

  return {
    \ 'x': a:x,
    \ 'y': a:y,
    \ 'w': a:w,
    \ 'h': a:h,
    \ 'fgb': l:fgb,
    \ 'bgb': l:bgb,
    \ 'fgw': l:fgw,
    \ 'bgw': l:bgw,
    \ 'open': 1
    \ }
endfunction

fu! s:core_window_toggle(wo)
  let l:wo = a:wo
  try

    if l:wo.open == 1
      " TODO delete border buf

      call nvim_set_current_win(l:wo.fgw) | hide
      call nvim_set_current_win(l:wo.bgw) | hide

      " can't simply invert a dictionary property, sadly
      let l:wo.open = 0

    elseif l:wo.open == 0
      let l:wo = s:core_window_create(l:wo.x, l:wo.y, l:wo.w, l:wo.h, l:wo)
      let l:wo.open = 1
    en
  catch
  endtry

  return l:wo
endfunction

" ------------------------------------------------------------------------------
"  core functions - clear
" ------------------------------------------------------------------------------

com! Clear call s:clear_buffers()
fu! s:clear_buffers()
  let l:bl = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let l:tab = tabpagenr()
  try
    let l:win = 0
    while l:win < winnr('$')
      let l:win += 1
      call remove(l:bl, index(l:bl, winbufnr(l:win)))
    endwhile

    if len(l:bl)
      exe 'bw' join(l:bl)
    endif
  finally
    " original tab
    exe 'tabnext' l:tab
  endtry
endfunction

" ------------------------------------------------------------------------------
"  tags
" ------------------------------------------------------------------------------

nnoremap <M-[> <Esc>:Tags<CR>
vnoremap <M-[> <Esc>:Tags<CR>

exe 'set tags+='.s:sessDir.'/tags'

com! GenTags call s:gen_tags()
fu! s:gen_tags()
  exe 'silent !mkdir -p ' . s:sessDir
  exe 'silent !ctags --tag-relative=always -R -f ' . s:sessDir . '/tags . &'
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

nnoremap <silent> <M-p> <Esc>:Files<CR>
vnoremap <silent> <M-p> <Esc>:Files<CR>

" buffers
nnoremap <silent> <M-B> <Esc>:Buffers<CR>
vnoremap <silent> <M-B> <Esc>:Buffers<CR>

" git
nnoremap <silent> <M-G> <Esc>:GFiles?<CR>
vnoremap <silent> <M-G> <Esc>:GFiles?<CR>

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
" disregard .gitignore and .git files
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'

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
nnoremap <C-c> "+ygv

nnoremap <C-v> o<Esc>"+p

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
  \ "Modified"  : s:vcs,
  \ "Staged"    : s:vcs,
  \ "Untracked" : s:vcs,
  \ "Renamed"   : s:vcs,
  \ "Unmerged"  : s:vcs,
  \ "Deleted"   : s:vcs,
  \ "Dirty"     : s:vcs,
  \ "Clean"     : s:vcs,
  \ 'Ignored'   : s:vcs,
  \ "Unknown"   : s:vcs
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

fu! GitBranch()
  let l:branch = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  let l:branch = strlen(l:branch) > 0 ? ' ' . l:branch . ' ' : ''

  if strlen(l:branch) > 20 | let l:branch = l:branch[0:17] . '...' | en
  return l:branch
endfunction

" TODO merge conflict highlight https://github.com/rhysd/conflict-marker.vim/blob/master/autoload/conflict_marker.vim

" ------------------------------------------------------------------------------
"  terminal management
" ------------------------------------------------------------------------------

" total num of terminal bufs available
" let s:num_total_term_bufs = 4

" let s:termbl = []
" for i in range(s:num_total_term_bufs)
"   call add(s:termbl, -1)
"   let n = i + 1 
"   exe 'tnoremap <M-'.n.'> <C-\><C-n>:TerminalFocus '.n.'<CR>' 
" endfor

for m in ['n', 'i', 'v', 't']
  exe m.'noremap <M-`> <C-\><C-n>:TerminalToggle<CR>'
endfor

let s:termwo = {}

" terminal buffer list index
" let s:termbli = -1

com! TerminalToggle call s:terminal_win_toggle()

fu! s:terminal_win_toggle()
  try
    if s:termwo.open == 1 " terminal window is open
      let s:termwo = g:Win_Toggle(s:termwo)

    else " terminal window is closed
      let l:bufWasDeleted = s:termwo.fgb < 0

      let s:termwo = g:Win_Toggle(s:termwo)

      if l:bufWasDeleted
        call termopen('zsh', {'on_exit': 'Terminal_exit'})
      en

      startinsert
    en
  catch " terminal window does not yet exist
    let l:x = 0.1
    let l:y = 0.1
    let l:w = 0.8
    let l:h = 0.8

    let s:termwo = g:Win_New(l:x, l:y, l:w, l:h)
    call termopen('zsh', {'on_exit': 'Terminal_exit'})
    startinsert
  endtry
endfunction

com! -nargs=1 TerminalFocus 
  \call s:terminal_focus(<f-args>)

fu! s:terminal_focus(index)
endfunction

fu! Terminal_exit(job_id, code, event) dict
  " sanity check
  call nvim_set_current_buf(s:termwo.fgb)
  bw!
  call nvim_set_current_buf(s:termwo.bgb)
  bw!
  try
    let s:termwo.open = 0
    let s:termwo.fgb = -1
  catch
  endtry
endfunction

" ------------------------------------------------------------------------------
"  status bar / tabline
" ------------------------------------------------------------------------------

fu! GetStatusInactive()
endfunction

fu! GetStatusActive()
  set statusline=
  set statusline+=%#Mode#
  " StatusLineMode declared in colors.vim
  set statusline+=\ %{StatusLineMode()}
  set statusline+=\ %#constant#
  set statusline+=%{GitBranch()}
  set statusline+=%#FileName#
  set statusline+=\ %t
  set statusline+=\ %r

  set statusline+=%=

  set statusline+=%#StatusLne#
  set statusline+=%{'Ln\ '}
  set statusline+=%l
  set statusline+=%{',\ Col\ '}
  set statusline+=%c
  set statusline+=%#FileName#
  set statusline+=\ %y
endfunction

set laststatus=2
set statusline=%!GetStatusActive()

augroup status_bar_tabline
  au!
  au WinEnter * setlocal statusline=%!GetStatusActive()
  au WinLeave * setlocal statusline=%!GetStatusInactive()
  au TermLeave * setlocal statusline=%!GetStatusActive()
augroup end

" ------------------------------------------------------------------------------
"  code folding
" ------------------------------------------------------------------------------

set foldmethod=syntax
" TEMP
set nofoldenable
" set foldenable
set foldnestmax=10
set foldlevelstart=1

" let javaScript_fold = 1
" let ruby_fold = 1
" let sh_fold_enabled = 1

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

" TODO https://github.com/mileszs/ack.vim

" ------------------------------------------------------------------------------
"  appearance
" ------------------------------------------------------------------------------

" line numbers
set number

" show matching brackets
set showmatch

" open vertical windows to the right
set splitright

" number of lines above and below cursor at all times
set scrolloff=5

so $XDG_CONFIG_HOME/nvim/colors.vim

" TODO emmet?
" TODO tag search with fzf.vim
" TODO remove fzf.vim except preview
" TODO better tags in js,jsx,ts,tsx
" TODO tagbar plugin?
" TODO f2 refactor
