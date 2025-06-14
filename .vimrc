set nocompatible              " be iMproved, required for Vundle
filetype off                  " required for Vundle

"************ VUNDLE & PLUGINS ************"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle manages itself
Plugin 'VundleVim/Vundle.vim'
" Sane default configuration
Plugin 'tpope/vim-sensible'
" Provides color schemes!
Plugin 'rafi/awesome-vim-colorschemes'
" Stylish bottom bar
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Easy commenting with gc{selection} keystroke
Plugin 'tpope/vim-commentary'
" Wide language support + indenting goodies
Plugin 'sheerun/vim-polyglot'
" Git line changes shown in left bar
Plugin 'airblade/vim-gitgutter'
" Autocompletion and snippets with tab
Plugin 'ervandew/supertab'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

call vundle#end()
filetype plugin indent on    " required

"************ GLOBAL SETTINGS ************"

" Increase update time so that plugins work more fluidly
set updatetime=100

" Enable syntax processing
syntax enable

"************ VISUAL CUSTOMIZATION ************"
" Color scheme
colorscheme gruvbox
set bg=dark

" Bottom bar (vim-airline plugin)
let g:airline_theme='papercolor'

" Disable background color erase
if &term =~ '256color'
    set t_ut=
endif

" Show line numbers
set number

" Show matching [{()}]
set showmatch

" Show command and autocompletion in command menu
set showcmd
set wildmenu

" Show the sign column always
set signcolumn=yes
hi SignColumn ctermbg=bg guibg=bg

"************ KEY REMAPS ************"
" Helix-like buffer navigation
nmap gn :bn<CR>
nmap gp :bp<CR>

" vim-gitgutter commands
" Git hunk diff/view/stage/undo
nmap ghd :GitGutterDiffOrig<CR>
nmap ghv <Plug>(GitGutterPreviewHunk)
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
" Select in hunk or in hunk including afterwards... Is this actually useful?
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" Make next/prev hunk wrap around ends of the document
function! GitGutterNextHunkCycle()
  let line = line('.')
  silent! GitGutterNextHunk
  if line('.') == line
    1
    GitGutterNextHunk
  endif
endfunction

function! GitGutterPrevHunkCycle()
  let line = line('.')
  silent! GitGutterPrevHunk
  if line('.') == line
    $
    GitGutterPrevHunk
  endif
endfunction

nmap ghn :call GitGutterNextHunkCycle()<CR>
nmap ghp :call GitGutterPrevHunkCycle()<CR>



"************ EDITING FUNCTIONALITY ************"

" Indentation uses 4 spaces
set expandtab
set tabstop=4
set shiftwidth=4
set autoindent

" Line wrapping
set wrap

" Searching
set incsearch
set hlsearch

" 100 character line guide
set textwidth=100
set colorcolumn=100

" Leave space at the bottom of the screen when scrolling
set scrolloff=10
set sidescroll=1
set sidescrolloff=10

" Open new panes to the right
set splitright

" Autocompletion with Tab
let g:SuperTabDefaultCompletionType='context'
let g:SuperTabContextDefaultCompletionType = "<c-n>"

"************ FILETYPE SUPPORT ************"
" Map custom file extensions to standard formats
autocmd BufNewFile,BufRead *.gv set filetype=verilog
autocmd BufNewFile,BufRead *.vpy  set filetype=verilog
autocmd BufNewFile,BufRead *.vhpy set filetype=verilog
autocmd BufNewFile,BufRead *.gsv set filetype=verilog_systemverilog
autocmd BufNewFile,BufRead *.svpy  set filetype=verilog_systemverilog
autocmd BufNewFile,BufRead *.svhpy set filetype=verilog_systemverilog

" Add comment strings for common filetypes
autocmd FileType verilog setlocal commentstring=//\ %s
autocmd FileType systemverilog setlocal commentstring=//\ %s
autocmd FileType verilog_systemverilog setlocal commentstring=//\ %s

