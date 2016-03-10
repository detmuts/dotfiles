" Plugged
" -------
call plug#begin('~/.config/nvim/plugged')

"Editing
Plug 'junegunn/vim-easy-align', { 'on': ['<PLug>(EasyAlign)', 'EasyAlign'] }
Plug 'junegunn/goyo.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'Raimondi/delimitmate'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/echodoc.vim', { 'on': 'EchoDocEnable' }
Plug 'Shougo/context_filetype.vim'

"Searching
Plug 'mhinz/vim-grepper', { 'on': 'Grepper' }
Plug 'junegunn/fzf', { 'on': 'FZF', 'dir': '~/.fzf', 'do': './install --all' }

"Language specific
Plug 'zchee/deoplete-jedi'

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
set lazyredraw
set noswapfile
set noshowmode
set autoindent
set number
set ruler
set backspace=indent,eol,start
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

let mapleader="\<Space>"    "Trying this out

" Esc timeout because neovim
set nottimeout

" Motions
map H ^
map L $

" Searching
set incsearch
set ignorecase
set smartcase

" Mapping
nnoremap Q <nop>
nnoremap <silent> <C-l> :nohl<CR><C-l>

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
inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Deoplete.nvim
let g:deoplete#enable_at_startup = 1
autocmd CompleteDone * pclose!
set splitbelow

" Echodoc
let g:echodoc_enable_at_startup = 1

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
let g:airline_exclude_preview=1
let g:airline_theme='base16_ocean'
let g:airline_left_sep=''
let g:airline_right_sep=''
