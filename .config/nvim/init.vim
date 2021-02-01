" --- Plugins ---
call plug#begin()

Plug 'tmhedberg/SimpylFold'
Plug 'vim-scripts/indentpython.vim'
Plug 'vim-syntastic/syntastic'
Plug 'nvie/vim-flake8'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'Raimondi/delimitMate'
Plug 'dense-analysis/ale'
Plug 'Yggdroot/indentLine'
Plug 'preservim/nerdcommenter'

" c
Plug 'vim-scripts/c.vim', {'for': ['c', 'cpp']}
Plug 'ludwig/split-manpage.vim'


" html
Plug 'hail2u/vim-css3-syntax'
Plug 'gko/vim-coloresque'
Plug 'tpope/vim-haml'
Plug 'mattn/emmet-vim'


" javascript
Plug 'jelera/vim-javascript-syntax'


" python
Plug 'davidhalter/jedi-vim'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

call plug#end()

filetype plugin indent on

" --- NERDTree ---
let g:NERDTreeShowHidden=1
let g:NERDTreeChDirMode=2
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent='<RightMouse>'
let g:NERDTreeWinSize=50
nnoremap <C-F> :NERDTreeFind<CR>
nnoremap <C-Space> :NERDTreeToggle<CR>

" --- NERDCommenter ---
nmap <C-_> <Plug>NERDCommenterInvert
vmap <C-_> <Plug>NERDCommenterInvert

" --- Airline ---
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#ale#enabled=1
let g:airline_skip_empty_sections=1
let g:airline_theme='bubblegum'

" --- SilverSearcher ---
let g:ackprg='ag --vimgrep'

" --- Fugitive ---
if exists("*fugitive#statusline")
	set statusline+=%{fugitive#statusline()}
endif

" --- Git ---
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gsh :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

" --- Splits ---
" split behavior
set splitbelow
set splitright

" split mappings
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

" split navigations
" hjkl
nnoremap <C-K> <C-W><C-K>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>

" arrows
nnoremap <C-Up> <C-W><C-Up>
nnoremap <C-Down> <C-W><C-Down>
nnoremap <C-Left> <C-W><C-Left>
nnoremap <C-Right> <C-W><C-Right>

" --- Folding ---
set foldmethod=indent
set foldlevel=99

nnoremap <space> za

" --- Indents ---
" python
au BufNewFile,BufRead *.py
	\ set tabstop=4
	\ set softtabstop=4
	\ set shiftwidth=4
	\ set textwidth=79
	\ set expandtab
	\ set autoindent
	\ set fileformat=unix

" web
au BufNewFile,BufRead *.js, *.html, *.css
	\ set tabstop=2
	\ set softtabstop=2
	\ set shiftwidth=2

" --- Search ---
set hlsearch
set ignorecase
set incsearch
set smartcase

" --- Abbreviations ---
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" --- Misc ---
"  remove trailing whitespace
command! FixWhitespace :%s/\s\+$//e

set encoding=utf-8
set number
syntax enable
set linebreak
set mouse=a
set backspace=indent,eol,start
set cursorline

set noerrorbells
set visualbell

set diffopt+=vertical

nnoremap j gj
nnoremap <down> gj
nnoremap k gk
nnoremap <up> gk

nnoremap n nzzzv
nnoremap N Nzzzv

nmap <C-C> "+y
vmap <C-C> "+y
nmap <C-V> "+p
vmap <C-V> "+p

nmap <C-A> ggVG
vmap <C-A> ggVG

let mapleader=','

set hidden

if exists('$SHELL')
	set shell=$SHELL
else
	set shell=/bin/sh
endif
