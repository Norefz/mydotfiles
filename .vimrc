"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               
"               
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║     
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"               
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"plugins
call plug#begin()
Plug 'fladson/vim-kitty'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'frazrepo/vim-rainbow'
Plug 'gorodinskiy/vim-coloresque'
Plug 'francoiscabrol/ranger.vim'
Plug 'neovim/nvim-lspconfig'
Plug 'SmiteshP/nvim-navic'
call plug#end()


" set number.
  set number
"turn syntax highlight on.
syntax on
"enable type file detection.
filetype on
"enable plugin.
filetype plugin on "load an indent file or detected file.
filetype indent on
"higlight searching.
set incsearch 
"Ignore capital letters during search.
set ignorecase
"overrude the ignorecase option when searching for capital.
set smartcase
"show partial commmand type in the las line.
set showcmd
"show the mode you are on the last line.
set showmatch
"use hightlight when search.
set hlsearch
"set the command to sae in history default is 20.
set history=1000
"Set the Background tone.
set background=dark
"set jj to esc.
inoremap jj <esc>
set whichwrap=<,>,h,l
"show error signs in number coloumn.
set signcolumn=number
" Status bar.
set laststatus=2
"Rendering.
set ttyfast
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
let g:rainbow_active = 1
