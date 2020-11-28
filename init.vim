" neovim configuration by Sam Bossley

" ------------------------------------------------------------------------------
"  globals
" ------------------------------------------------------------------------------

" directory where all cacheable data is stored
let g:data_dir = expand('$XDG_DATA_HOME/nvim/')

" directory where nvim configuration is located
let g:install_dir = expand('$XDG_CONFIG_HOME/nvim')

" shell used for terminal buffer windows
let s:shell_name = '$SHELL_NAME'
if ! s:shell_name | let s:shell_name = 'sh' | endif

" ------------------------------------------------------------------------------
"  plugin declaration
" ------------------------------------------------------------------------------

" automated plugin installation process:
" if vim-plug directory is empty
let s:vimPlugDir = g:data_dir . 'site/autoload/plug.vim'
if empty(glob(s:vimPlugDir))
  " install vim-plug
  exe '!curl -fLo ' . s:vimPlugDir . ' --create-dirs '
    \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  " install plugins
  au VimEnter * PlugInstall --sync | so $MYVIMRC
endif

" plugin list
call plug#begin(g:data_dir . 'plugged')

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'iamcco/markdown-preview.nvim',
  \{ 'do': { -> mkdp#util#install() },
  \'for': ['markdown', 'vim-plug']}
Plug 'dense-analysis/ale'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'tpope/vim-commentary'
Plug 'sheerun/vim-polyglot'
Plug 'APZelos/blamer.nvim'
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
  au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc,init.vim so $MYVIMRC
augroup end

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
  " if session exists
  if filereadable(s:sessFile)
    exe 'so ' . s:sessFile
  en
endf

" s:openedDir is true if nvim was opened with a directory
" s:dir represents the current project directory

let s:openedDir = eval('@%') == '' && argc() == 0
let s:dir = trim(execute('pwd'))

" if dir path is supplied as an arg, e.g. nvim ./Downloads/TestFolder/
if isdirectory(eval('@%'))
  let s:openedDir = 1
  let s:dir = eval('@%')
endif

" resolve resolves any symbolic links
" fnamemodify makes sure that the path is an absolute path
" (trailing slash is included)
" fnameescape escapes file paths with spaces, e.g. My\ Documents/

let s:dir = fnameescape(fnamemodify(resolve(s:dir), ':p'))

let s:sessDir = g:data_dir . 'sessions' . s:dir
let s:sessFile = s:sessDir . 'se'

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

let s:nav_jump = $VI_NAV_JUMP
if ! s:nav_jump | let s:nav_jump = 5 | endif

let s:nav_jump_large = $VI_NAV_JUMP_LARGE
if ! s:nav_jump_large | let s:nav_jump_large = 25 | endif

" no help docs!
nnoremap K k

" no double taps
" I know it blocks the default binding, used for useful stuff like
" yiw and yaw, but I rarely want to copy words. I'd rather use
" diw and daw for such things
" nnoremap y yy

" M-Space to insert a space in normal mode
nnoremap <M-Space> i<Space><Esc>

" vanilla tip: <C-g> to view path

" line ends
nnoremap ! 0
nnoremap @ $

" <CR>, <Esc>, <BS> basics
inoremap <M-h> <BS>
inoremap <M-;> <Esc>
inoremap <M-j> <CR>

cnoremap <M-;> <Esc>

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

exe 'nnoremap <M-d> ' . s:nav_jump_large . 'j'
exe 'nnoremap <M-u> ' . s:nav_jump_large . 'k'
exe 'vnoremap <M-d> ' . s:nav_jump_large . 'j'
exe 'vnoremap <M-u> ' . s:nav_jump_large . 'k'

" nohl
nnoremap <Space> :noh<CR>

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
"  core functions - multi-mode binding
" ------------------------------------------------------------------------------

fu! s:bind_all_modes(binding)
  for m in ['n', 'i', 'v', 't']
    exe m . 'noremap ' . a:binding
  endfor
endfunction

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
      call nvim_set_current_win(l:wo.fgw) | hide
      " border buffer is deleted by 
      " default since it is 'unmodifiable'
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
"  mouse events
" ------------------------------------------------------------------------------

set mouse=a

" ------------------------------------------------------------------------------
"  fuzzy file finding
" ------------------------------------------------------------------------------

fu! g:Fzf()
  call fzf#run(fzf#wrap({
    \'source': 'rg --files',
    \'options': '--preview "cat {}"'
    \}))
endfunction

com! Fzf call g:Fzf()

" files
nnoremap <silent> <M-p> <Esc>:Fzf<CR>
vnoremap <silent> <M-p> <Esc>:Fzf<CR>

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

com! NERDTreeToggleAdjusted call s:NERDTreeToggle()

let s:hasTreeBeenOpened = 0
fu! s:NERDTreeToggle()
  if ! s:hasTreeBeenOpened
    let s:hasTreeBeenOpened = 1
    exe 'NERDTreeToggle ' . s:dir
  else
    NERDTreeToggle
  endif
endfunction

" toggle explorer pane
call s:bind_all_modes('<M-b> <Esc>:NERDTreeToggleAdjusted<CR>')

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
" suppress bookmarks file
let NERDTreeBookmarksFile = g:data_dir."/bookmarks"

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

let g:NERDTreeGitStatusIndicatorMapCustom = {
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

" ------------------------------------------------------------------------------
"  terminal management
" ------------------------------------------------------------------------------

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

fu! s:terminal_win_toggle()
  try
    if s:termwo.open == 1 " terminal window is open
      let s:termwo = g:Win_Toggle(s:termwo)

    else " terminal window is closed
      let s:termwo.fgb = s:tbl[s:tbli]
      let l:bufWasDeleted = s:termwo.fgb < 0

      let s:termwo = g:Win_Toggle(s:termwo)

      if l:bufWasDeleted
        call termopen(s:shell_name, {'on_exit': 'Terminal_exit'})
      en

      startinsert
    en
  catch " terminal window does not yet exist
    let l:x = 0.1
    let l:y = 0.1
    let l:w = 0.8
    let l:h = 0.8

    let s:tbli = 0

    let s:termwo = g:Win_New(l:x, l:y, l:w, l:h)
    call termopen(s:shell_name, {'on_exit': 'Terminal_exit'})
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
  call nvim_set_current_buf(s:termwo.fgb)
  bw!
  call nvim_set_current_buf(s:termwo.bgb)
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
  return '-- INACTIVE --'
endfunction

fu! GetStatusActive()
  set statusline=
  set statusline+=%#Mode#
  " StatusLineMode declared in colors.vim
  set statusline+=\ %{StatusLineMode()}
  set statusline+=\ %#GitBranch#
  set statusline+=%{GitBranch()}
  set statusline+=%#FileName#
  set statusline+=\ %f
  set statusline+=\ %r

  set statusline+=%=

  set statusline+=%#StatusLne#
  set statusline+=%{'Ln\ '}
  set statusline+=%l
  set statusline+=%{',\ Col\ '}
  set statusline+=%c
  set statusline+=\ %p%{'%'}
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

" set foldmethod=syntax
" set nofoldenable
" set foldenable
" set foldnestmax=10
" set foldlevelstart=1

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

" clang-format needs to be installed separately, usually contained under the name 
" clang on most distributions and operating systems

let g:ale_fixers = {
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\   'cs': ['clang-format'],
\   'css': ['prettier'],
\   'googlescript': ['prettier'],
\   'markdown': ['prettier'],
\   'javascript': ['prettier'],
\   'scss': ['prettier'],
\   'typescript': ['prettier'],
\   'typescriptreact': ['prettier'],
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

" normal J moves lines up
" normal K moves lines down
nnoremap K i<CR><C-c>

" ------------------------------------------------------------------------------
"  file/project search
" ------------------------------------------------------------------------------

" nnoremap <M-f> <Esc>:BLines<CR>
" vnoremap <M-f> <Esc>:BLines<CR>
nnoremap <M-f> <Esc>/

" primarily use Rg every time over fzf because otherwise it matches individual 
" lines of the same name file
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

nnoremap <M-F> <Esc>:RG<CR>
vnoremap <M-F> <Esc>:RG<CR>

" ------------------------------------------------------------------------------
"  coc
" ------------------------------------------------------------------------------

let g:coc_disable_startup_warning = 1
" remove python2 support
let g:loaded_python_provider = 0

" TODO fix incorrect installation of extensions
" extensions to install by default
" let g:coc_global_extensions = [
"   \ 'coc-clangd',
"   \ 'coc-css',
"   \ 'coc-json',
"   \ 'coc-tsserver'
"   \ ]

augroup coc
  au!
  " support comment highlighting in json
  au FileType json syntax match Comment +\/\/.\+$+
augroup end

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

" ------------------------------------------------------------------------------
"  markdown preview
" ------------------------------------------------------------------------------

com! D MarkdownPreview

" prevent auto closing
let g:mkdp_auto_close = 0

" reset md preview title
let g:mkdp_page_title = '${name}'

" ------------------------------------------------------------------------------
"  latex
" ------------------------------------------------------------------------------

let s:isLiveLatexEnabled = 0
let s:isLiveLatexPreviewOpen = 0

let g:defaultPdfViewer = $PDF_VIEWER

com! L call s:enable_latex_live_preview()
com! LatexLivePreview call s:enable_latex_live_preview()

fu! s:enable_latex_live_preview()
  let s:isLiveLatexEnabled = 1
  let s:isLiveLatexPreviewOpen = 0
  call s:update_latex_live_preview()
endfunction

fu! s:compile_latex()
  let l:compile = 'pdflatex -output-directory ' . expand("%:h") . ' ' . expand("%:p")

  exe 'silent !' . l:compile

  " compile twice for refs and labels
  " comment kept for clarity but functionality removed due to performance.
  " It is rare we will need have references or bibliography, and both can
  " be run manually as needed.

  " exe 'silent !biber ' . expand("%:r")
  exe 'silent !' . l:compile
endfunction

fu! s:update_latex_live_preview()
  call s:compile_latex()
  let output = expand("%:p:r") . '.pdf'

  if ! s:isLiveLatexPreviewOpen
    let s:isLiveLatexPreviewOpen = 1
    exe 'silent !' g:defaultPdfViewer . ' ' . output . ' &'
  en
endfunction

augroup latex
  au BufWritePost *.tex if s:isLiveLatexEnabled
    \ | call s:update_latex_live_preview() | en
  " disable linters for latex because they all suck :')
  au BufEnter *.tex ALEDisableBuffer
  au BufEnter *.bib ALEDisableBuffer
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
let themeArr = split(system("xgetres theme.mode"), "\n")
let g:theme = themeArr[0]

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
  au BufReadPost *.dat set filetype=dat | set syntax=json
  au BufReadPost *.gs set filetype=googlescript | set syntax=javascript
  au BufReadPost *.h set filetype=c | set syntax=c
  au BufReadPost config set filetype=dosini | set syntax=dosini
  au BufReadPost gtkrc set filetype=sh | set syntax=sh
  au BufReadPost *.bib set filetype=tex | set syntax=bib
augroup end

exe 'so ' . g:install_dir . '/colors.vim'
