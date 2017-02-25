" Plugged
" -------
call plug#begin('~/.config/nvim/plugged')

"Editing
Plug 'junegunn/vim-easy-align', { 'on': ['<PLug>(EasyAlign)', 'EasyAlign'] }
Plug 'junegunn/goyo.vim'
Plug 'Raimondi/delimitmate'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/echodoc.vim', { 'on': 'EchoDocEnable' }
Plug 'Shougo/context_filetype.vim'

"Searching
Plug 'mhinz/vim-grepper', { 'on': 'Grepper' }
Plug 'junegunn/fzf', { 'on': 'FZF', 'dir': '~/.fzf', 'do': './install --all' }

"Language specific
Plug 'zchee/deoplete-jedi'
Plug 'osyo-manga/vim-monster'
Plug 'carlitux/deoplete-ternjs'

"Navigation
Plug 'easymotion/vim-easymotion'

"Pretty colours
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'

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

map <C-t>l :tabp<CR>
map <C-t>h :tabn<CR>
map <C-t>j :tabr<CR>
map <C-t>k :tabl<CR>


" Show whitespace
set list
set listchars=tab:\ \ ,trail:·

" Colourscheme
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

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

" Easymotion (char, char-char, line, word)
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map  <Leader>n <Plug>(easymotion-overwin-f)
nmap <Leader>s <Plug>(easymotion-overwin-f2)
map  <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
map  <Leader>j <Plug>(easymotion-j)
map  <Leader>k <Plug>(easymotion-k)

" Delimitmate
let delimitMate_expand_cr=1
let delimitMate_expand_space=1

" Ultisnips
inoremap <silent><expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Deoplete.nvim
autocmd CompleteDone * pclose!
set splitbelow
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})

" Deoplete-jedi
let g:deoplete#sources#jedi#enable_cache = 0

" Monster-vim
let g:deoplete#omni#input_patterns.ruby = ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']

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
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline_exclude_preview=1
let g:airline_theme='hybridline'
let g:airline_left_sep=''
let g:airline_right_sep=''

autocmd FileType ruby,erb,html,javascript,yaml setlocal shiftwidth=2 tabstop=2

" Functions
"
" Show tab number in tabline
if exists("+showtabline")
     function MyTabLine()
         let s = ''
         let t = tabpagenr()
         let i = 1
         while i <= tabpagenr('$')
             let buflist = tabpagebuflist(i)
             let winnr = tabpagewinnr(i)
             let s .= '%' . i . 'T'
             let s .= (i == t ? '%1*' : '%2*')
             let s .= ' '
             let s .= i . ')'
             let s .= ' %*'
             let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
             let file = bufname(buflist[winnr - 1])
             let file = fnamemodify(file, ':p:t')
             if file == ''
                 let file = '[No Name]'
             endif
             let s .= file
             let i = i + 1
         endwhile
         let s .= '%T %#TabLineFill#%='
         let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
         return s
     endfunction
     set stal=2
     set tabline=%!MyTabLine()
endif

