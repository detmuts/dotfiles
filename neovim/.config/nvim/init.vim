" Plugged
" -------
call plug#begin('~/.vim/plugged')

"Editing
Plug 'junegunn/vim-easy-align', { 'on': ['<PLug>(EasyAlign)', 'EasyAlign'] }
Plug 'junegunn/goyo.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'Raimondi/delimitmate'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

"Searching
Plug 'mhinz/vim-grepper', { 'on': 'Grepper' }
Plug 'junegunn/fzf', { 'on': 'FZF', 'dir': '~/.fzf', 'do': './install --all' }

"Language specific
Plug 'davidhalter/jedi-vim'

"Navigation
"Plug 'easymotion/vim-easymotion'
"Plug 'junegunn/vim-peekaboo'

"Pretty colours
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kristijanhusak/vim-hybrid-material'

call plug#end()

filetype plugin indent on

let g:plug_timeout=6000

" General settings
" ----------------
syntax on
set nocompatible
set lazyredraw
set noswapfile
set autoindent
set noshowmode
set number
set ruler
set backspace=indent,eol,start
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

let mapleader="\<Space>"    "Trying this out

" Motions
map H ^
map L $

" Searching
set incsearch
set ignorecase
set smartcase

" Mapping
nnoremap Q <nop>

" Colorscheme
set background=dark
colorscheme hybrid_reverse

" Clipboard
if has ('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
end

" Write with sudo
cmap w!! w !sudo tee % > /dev/null

" Plugin settings
" ---------------

" NERDTree
map <Leader>t :NERDTreeToggle<CR>

" Delimitmate
let delimitMate_expand_cr=1
let delimitMate_expand_space=1

" Ultisnips
let g:UltiSnipsExpandTrigger="<C-l>"

" YouCompleteMe
let g:ycm_global_ycm_extra_conf="~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_autoclose_preview_window_after_insertion=1
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1 " Completion in comments
let g:ycm_complete_in_strings = 1 " Completion in string

" Grepper
nmap <Leader>ag :Grepper -tool ag -open -switch<cr>

" Fzf
nmap <Leader>f  :FZF<CR>

" Goyo
nmap <Leader>g :Goyo<CR>
let g:goyo_width=80
let g:goyo_heigth=85

" Airline
set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline_theme='base16_ocean'
let g:airline_left_sep=''
let g:airline_right_sep=''
