" neovim configuration by Sam Bossley

" ------------------------------------------------------------------------------
"  globals
" ------------------------------------------------------------------------------

" directory where all cacheable data is stored
let g:data_dir = expand('$XDG_DATA_HOME/nvim')

" directory where nvim configuration is located
let g:config_dir = expand('$XDG_CONFIG_HOME/nvim')

" current working directory and if opened with directory
" (fixes bug where the current directory returned from :pwd is inconsistent)
let g:opened_with_dir = 0
let s:args = argv()
if len(s:args) > 0 && isdirectory(s:args[0])
  exe 'cd '.s:args[0]
  let g:opened_with_dir = 1
endif
if len(s:args) == 0 | let g:opened_with_dir = 1 | endif
" resolve resolves any symbolic links
" fnameescape escapes file paths with spaces, e.g. My\ Documents/
let g:cwd = fnameescape(resolve(trim(execute('pwd'))))

" ------------------------------------------------------------------------------
"  plugin declaration
" ------------------------------------------------------------------------------

let s:vim_plug_dir = g:data_dir . '/site/autoload/plug.vim'
let s:plugin_dir = g:data_dir . '/plugins'

" automated plugin installation process:
" if vim-plug directory or plugin directory is empty
if empty(glob(s:vim_plug_dir)) || empty(glob(s:plugin_dir))
  " install vim-plug
  exe '!curl -fLo ' . s:vim_plug_dir . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  " install plugins, source vimrc, then quit
  au VimEnter * PlugInstall --sync | so $MYVIMRC | qa
endif

" plugin list
call plug#begin(s:plugin_dir)

Plug 'junegunn/fzf'
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" plugin compatibility and stop using vi utilities
set nocompatible
" enable plugins
filetype plugin on

" ------------------------------------------------------------------------------
"  configuration reloading
" ------------------------------------------------------------------------------

augroup reload_configuration
  au!
  au BufWritePost .vimrc,init.vim so $MYVIMRC
augroup end

" ------------------------------------------------------------------------------
"  defaults
" ------------------------------------------------------------------------------

" disable swap files
set noswapfile

" disable viminfo creation
set viminfo=""

" only search by case when using capital letters
set ignorecase
set smartcase

" search while typing
set incsearch
" display highlight
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

" enable mouse input
set mouse=a

" ------------------------------------------------------------------------------
"  clear inactive buffers
" ------------------------------------------------------------------------------

fu! s:clear_inactive_buffers()
  " get all buffers in list
  let l:all_bufs = split(execute('ls!'), '\n')

  " According to the help docs, removal of the current
  " element from a list does not negatively affect list
  " iteration. See ':h for' for more details.
  for l:buf in l:all_bufs
    let l:tokens = split(l:buf)
    if len(l:tokens) > 1
      " if buffers do not have flags, this will output
      " the buffer name - but this does not affect the
      " output (see below)
      let l:flags = l:tokens[1]

      let l:bufnr = l:tokens[0]
      " remove the 'u' from 'unlisted' buffer indices
      if l:bufnr =~ 'u'
        let l:bufnr = substitute(l:bufnr, 'u', '', '')
      en

      " if no flags are present, or flags are not
      " active/active current
      if len(l:tokens) < 5 ||
        \ (l:flags != 'a' &&
        \ l:flags != '#a' &&
        \ l:flags != '%a')

        " down with the guillotine!
        exe 'bw!'.l:bufnr
      en
    en
  endfor
endfunction

" ------------------------------------------------------------------------------
"  session management
" ------------------------------------------------------------------------------

let s:sess_dir = g:data_dir . '/sessions' . g:cwd
let s:sess_file = s:sess_dir . '/se'

" make session directory
call mkdir(s:sess_dir, 'p')

fu! s:session_save()
  " close side file explorer
  NERDTreeClose

  " keep only active (non-terminal) buffers
  call s:clear_inactive_buffers()

  " save session
  exe 'mksession! '.s:sess_file
endfunction

fu! s:session_restore()
  " if session exists, restore
  if filereadable(s:sess_file)
    exe 'so '.s:sess_file
  en
endfunction

augroup session_management
  au!
  au VimEnter * nested if g:opened_with_dir | call s:session_restore() | en
  au VimLeave * if g:opened_with_dir | call s:session_save() | en
augroup end

" ------------------------------------------------------------------------------
"  core mappings/bindings
" ------------------------------------------------------------------------------

let s:nav_jump = $VI_NAV_JUMP
if ! s:nav_jump | let s:nav_jump = 5 | endif

let s:nav_jump_large = $VI_NAV_JUMP_LARGE
if ! s:nav_jump_large | let s:nav_jump_large = 25 | endif

" no help docs!
nnoremap K k

" M-Space to insert a space in normal mode
nnoremap <M-Space> i<Space><Esc>

" <CR>, <Esc>, <BS> basics
inoremap <M-h> <BS>
inoremap <M-;> <Esc>
inoremap <M-j> <CR>

cnoremap <M-;> <Esc>

vnoremap <M-;> <Esc>

" basic buffer navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <M-h> <C-w>h
nnoremap <M-l> <C-w>l

nnoremap = <C-w>=

" basic vertical navigation
exe 'nnoremap <M-j> ' . s:nav_jump . 'j'
exe 'nnoremap <M-k> ' . s:nav_jump . 'k'
exe 'vnoremap <M-j> ' . s:nav_jump . 'j'
exe 'vnoremap <M-k> ' . s:nav_jump . 'k'

exe 'nnoremap <M-d> ' . s:nav_jump_large . 'j'
exe 'nnoremap <M-u> ' . s:nav_jump_large . 'k'
exe 'vnoremap <M-d> ' . s:nav_jump_large . 'j'
exe 'vnoremap <M-u> ' . s:nav_jump_large . 'k'

" nohl
nnoremap <Space> :noh<CR>

" closing and saving
nnoremap ZZ :xa<CR>
nnoremap ZQ :qa!<CR>

" to prevent annoying modals and errors
" from mistyping and clumsiness
com! W norm :w<CR>

" permutate insert...
" because I use this all the time...
" vnoremap I 0<C-v>I
" vnoremap A $<C-v>A

" ------------------------------------------------------------------------------
"  multi-mode binding
" ------------------------------------------------------------------------------

fu! s:bind_all_modes(binding)
  for m in ['n', 'i', 'v', 't', 'c']
    exe m . 'noremap ' . a:binding
  endfor
endfunction

" ------------------------------------------------------------------------------
"  core functions - floating window creator
" ------------------------------------------------------------------------------

let s:popup_opts = {
  \'x': 0.1,
  \'y': 0.1,
  \'w': 0.8,
  \'h': 0.8
  \}

" wrapper - when called with the above arguments, will return a
" preview window object and display the window
fu! g:Popup_new()
  return s:popup_new(
    \s:popup_opts.x,
    \s:popup_opts.y,
    \s:popup_opts.w,
    \s:popup_opts.h
    \)
endfunction

" wrapper - when called with a preview window object, will hide 
" or show the preview window
fu! g:Popup_toggle(winobj)
  return s:popup_toggle(a:winobj)
endfunction

fu! s:popup_new(x, y, w, h, ...)
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

fu! s:popup_toggle(wo)
  let l:wo = a:wo
  try

    if l:wo.open == 1
      call nvim_set_current_win(l:wo.fgw) | hide
      " border buffer is deleted by 
      " default since it is 'unmodifiable'
      call nvim_set_current_win(l:wo.bgw) | hide

      " can't simply invert a dictionary property, sadly
      let l:wo.open = 0

    elseif l:wo.open == 0
      let l:wo = s:popup_new(l:wo.x, l:wo.y, l:wo.w, l:wo.h, l:wo)
      let l:wo.open = 1
    en
  catch
  endtry

  return l:wo
endfunction

" ------------------------------------------------------------------------------
"  file/project search
" ------------------------------------------------------------------------------

let g:fzf_layout = { 'window': { 'width': s:popup_opts.w, 'height': s:popup_opts.h } }

function! s:fzf_open_from_line(lines)
  exe 'e '.g:cwd.'/'.a:lines[0]
endfunction

function! g:Fzf()
  call fzf#run(fzf#wrap({
    \'source': 'cd '.g:cwd.' && rg --files',
    \'options': '--preview "cat '.g:cwd.'/{}"',
    \'sink*': function('s:fzf_open_from_line')
    \}))
endfunction

com! Fzf call g:Fzf()

function! s:rg_open_from_line(lines)
  if len(a:lines) < 2 | return | endif
  let l:tokens = split(a:lines[1], ':')

  exe 'e '.g:cwd.'/'.l:tokens[0]
  call cursor(l:tokens[1], l:tokens[2])
endfunction

function! g:Rg(query)
  let l:pre_cmd = 'cd '.g:cwd.' && rg --column --line-number --no-heading --color=always --smart-case -- %s'
  let l:cmd = printf(l:pre_cmd, shellescape(a:query))

  let l:fzf_args = {
    \'source': l:cmd,
    \'options': [
      \'--ansi', '--phony',
      \'--query', a:query,
      \'--bind', 'change:reload:'.printf(l:pre_cmd, '{q}'),
      \'--preview',
      \g:config_dir.'/preview.sh {} {q} '.
        \float2nr(g:fzf_layout.window.height * &lines).
        \' '.g:cwd,
    \],
  \}

  let wrapped = fzf#wrap(l:cmd, l:fzf_args, 0)
  let wrapped['sink*'] = function('s:rg_open_from_line')

  call fzf#run(wrapped)
endfunction

com! -nargs=* Rg call g:Rg(<q-args>)

" files
nnoremap <silent> <M-p> <Esc>:Fzf<CR>
vnoremap <silent> <M-p> <Esc>:Fzf<CR>
" lines
nnoremap <silent> <M-F> <Esc>:Rg<CR>
vnoremap <silent> <M-F> <Esc>:Rg<CR>

" ------------------------------------------------------------------------------
"  file explorer
" ------------------------------------------------------------------------------

" activation toggle binding
call s:bind_all_modes('<silent> <M-b> <C-[>:NERDTreeToggle '.g:cwd.'<CR>')

" open files/folders similar to most terminal file broswers
let g:NERDTreeMapActivateNode = 'l'
let g:NERDTreeMapOpenRecursively = 'L'
let g:NERDTreeMapCloseDir = 'h'
let g:NERDTreeMapCloseChildren = 'H'

" hidden files
let g:NERDTreeMapToggleHidden = '<M-h>'

" unmap bindings
let g:NERDTreeMapChangeRoot = ''
let g:NERDTreeMapUpdir = ''
let g:NERDTreeMapUpdirKeepOpen = ''

" sort numbers like 1, 10, 11, 100, rather than 1, 10, 100, 11
let g:NERDTreeNaturalSort = 1
" color highlighted entry
let g:NERDTreeHighlightCursorLine = 1
" keep file explorer closed on open
let g:NERDTreeHijackNetrw = 0
" specify which files/folders to ignore
let g:NERDTreeIgnore =  ['^.git$', '^node_modules$']
" suppress bookmarks file
let g:NERDTreeBookmarksFile = g:data_dir . '/NERDTreeBookmarks'
" close explorer on file open
let g:NERDTreeQuitOnOpen = 1
" show hidden files on startup
let g:NERDTreeShowHidden = 1
" content displayed on the status line
let g:NERDTreeStatusline = ' '
" set window size
" let g:NERDTreeWinSize = 25
" hide bookmarks, help, etc
let g:NERDTreeMinimalUI = 1
" collapse folders if applicable
let g:NERDTreeCascadeSingleChildDir = 1
" delete buffers when renaming or deleting
let g:NERDTreeAutoDeleteBuffer = 1
" directory arrows
let g:NERDTreeDirArrowCollapsible = ' '
let g:NERDTreeDirArrowExpandable = ' '

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

" nnoremap <C-v> o<Esc>"+p

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

" shell used for terminal buffer windows
let s:shell_name = '$SHELL_NAME'
if ! s:shell_name | let s:shell_name = 'sh' | endif

" total num of terminal bufs available
let s:num_total_term_bufs = 4

let s:tbl = []
for i in range(s:num_total_term_bufs)
  call add(s:tbl, -1)
  let n = i + 1 
  exe 'tnoremap <M-'.n.'> <C-\><C-n>:TerminalFocus '.n.'<CR>' 
endfor

call s:bind_all_modes('<M-`> <C-\><C-n>:TerminalToggle<CR>')

let s:termwo = {}

" terminal buffer list index
let s:tbli = -1

com! TerminalToggle call s:terminal_win_toggle()

function! s:terminal_open()
  call termopen(
    \s:shell_name, {
      \'on_exit': 'Terminal_exit',
      \'cwd': g:cwd,
    \})
endfunction

fu! s:terminal_win_toggle()
  try
    if s:termwo.open == 1 " terminal window is open
      let s:termwo = g:Popup_toggle(s:termwo)

    else " terminal window is closed
      let s:termwo.fgb = s:tbl[s:tbli]
      let l:bufWasDeleted = s:termwo.fgb < 0

      let s:termwo = g:Popup_toggle(s:termwo)

      if l:bufWasDeleted
        call s:terminal_open()
      en

      startinsert
    en
  catch " terminal window does not yet exist
    let s:tbli = 0

    let s:termwo = g:Popup_new()
    call s:terminal_open()
    startinsert
  endtry

  let s:tbl[s:tbli] = s:termwo.fgb
endfunction

com! -nargs=1 TerminalFocus 
  \call s:terminal_focus(<f-args>)

fu! s:terminal_focus(index)
  " unfocus old window
  call s:terminal_win_toggle()
  " set new window
  let s:tbli = a:index - 1
  " focus new window
  call s:terminal_win_toggle()
endfunction

fu! Terminal_exit(job_id, code, event) dict
  " sanity check
  " call nvim_set_current_buf(s:termwo.fgb)
  bw!
  " call nvim_set_current_buf(s:termwo.bgb)
  bw!
  try
    let s:termwo.open = 0
    let s:termwo.fgb = -1

    let s:tbl[s:tbli] = -1
    let s:tbli = 0
  catch
  endtry
endfunction

" ------------------------------------------------------------------------------
"  status bar / tabline
" ------------------------------------------------------------------------------

fu! GetStatusInactive()
  " return ''
  return "%#InactiveMode# INACTIVE %#FileName#"
endfunction

fu! GetStatusActive()
  set statusline=
  set statusline+=%#Mode#
  set statusline+=\ %{StatusLineMode()}
  set statusline+=\ %#FileName#
  set statusline+=\ %f
  set statusline+=\ %r

  set statusline+=%=

  set statusline+=%#StatusLine#
  set statusline+=%{'Ln\ '}
  set statusline+=%l
  set statusline+=%{',\ Col\ '}
  set statusline+=%c
  set statusline+=\ %p%{'%'}
  set statusline+=%#FileName#
  set statusline+=\ %y
endfunction

set statusline=%!GetStatusActive()

augroup status_bar_tabline
  au!
  au WinEnter * setlocal statusline=%!GetStatusActive()
  au WinLeave * setlocal statusline=%!GetStatusInactive()
  au TermLeave * setlocal statusline=%!GetStatusActive()
augroup end

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

" normal J moves lines up
" normal K moves lines down
nnoremap K i<CR><C-c>

" ------------------------------------------------------------------------------
"  coc
" ------------------------------------------------------------------------------

let g:coc_disable_startup_warning = 1
" remove python2 support
let g:loaded_python_provider = 0

" extensions to install by default
let g:coc_global_extensions = [
  \ 'coc-clangd',
  \ 'coc-css',
  \ 'coc-json',
  \ 'coc-omnisharp',
  \ 'coc-prettier',
  \ 'coc-tsserver',
  \ ]

" M-j and M-k navigates completion
inoremap <silent><expr> <M-j>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><M-k> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" M-g triggers completion
inoremap <silent><expr> <M-g> coc#refresh()

" M-l confirms completion
if exists('*complete_info')
  inoremap <expr> <M-l> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <M-l> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
endif

" coc's fake tag stack (tm)
nmap <silent> <M-]> <plug>(coc-definition)
nnoremap <M-o> <C-o>

" gk or gh for documentation/typing
nnoremap <silent> gk :call <sid>show_documentation()<cr>
nnoremap <silent> gh :call <sid>show_documentation()<cr>
fu! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    exe 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  en
endfunction

" prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" formatter
augroup coc
  au!
  au BufWritePost *.rs exe 'silent !rustfmt '.@% | e!
augroup end

" ------------------------------------------------------------------------------
"  file preview
" ------------------------------------------------------------------------------

fu! s:generate_preview()
  if exists('b:is_preview_enabled') |
    " markdown
    if &filetype == 'markdown'
      if executable('pandoc')
        exe 'silent !pandoc --metadata title="'.
          \expand('%:p').'" -s '.
          \'-o '.b:tmp_file_wo_ext.'.html '.
          \expand('%:p').' &'
      en
    " latex
    elseif (&filetype == 'tex' || &filetype == 'latex')
      if executable('pdflatex')
        let l:cmd = 'pdflatex -output-directory '.
          \g:cwd.'/'.expand("%:h").' '.expand("%:p")

        exe 'silent !'.l:cmd
      en
    en
  en
endfunction

fu! s:close_preview()
  if exists('b:is_preview_enabled')
    \ && exists('b:tmp_file_wo_ext')
    if &filetype == 'markdown'
      exe 'silent !rm '.b:tmp_file_wo_ext.'.html &'
    en
  en
endfunction

fu! g:Enable_preview()
  let b:is_preview_enabled = 1

  exe 'let b:tmp_file_wo_ext = "'.
    \expand('%:p:h').'/.__nvim__'.
    \expand('%').
    \'"'

  call s:generate_preview()

  " open preview
  if &filetype == 'markdown'
    exe 'silent !$BROWSER file:///'.
      \b:tmp_file_wo_ext.'.html &'
  elseif (&filetype == 'tex' || &filetype == 'latex')
    let output = expand("%:p:r") . '.pdf'
    exe 'silent !$PDF_VIEWER ' . output . ' &'
  en
endfunction

com! L call g:Enable_preview()

augroup file_preview
  au!
  au BufEnter * if ! exists('b:is_preview_enabled') |
    \ let b:is_preview_enabled = 0 | en
  au BufWritePost * if b:is_preview_enabled |
    \ call s:generate_preview() | en
  au VimLeavePre,BufDelete,BufWipeout * if exists('b:is_preview_enabled') |
    \ call s:close_preview() | en
augroup end

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

" trailing space characters
set list listchars=tab:\ \ ,trail:·

" theme setting for readable syntax highlighting
let g:theme = split(system("xgetres theme.mode"), "\n")[0]

if ! exists('g:theme')
  let g:theme = $CURRENT_THEME_MODE
endif

if exists('g:theme') && g:theme == 'light'
  set background=light
else
  set background=dark
endif

" various file-specific syntax highlighting
augroup appearance_syntax_highlight
  au!
  au BufReadPost config set filetype=dosini | set syntax=dosini
  au BufReadPost gtkrc set filetype=sh | set syntax=sh
  " support comment highlighting in json
  au FileType json syntax match Comment +\/\/.*$+
  au BufReadPost *.bib set filetype=tex | set syntax=bib
  au BufReadPost *.dat set filetype=dat | set syntax=json
  au BufReadPost *.gs set filetype=googlescript | set syntax=javascript
  au BufReadPost *.h set filetype=c | set syntax=c
  au BufReadPost *.m3u set filetype=m3u
  au Filetype m3u setl commentstring=#\ %s
  au Filetype m3u syntax match Comment +#.*$+
augroup end

exe 'so ' . g:config_dir . '/colors.vim'
