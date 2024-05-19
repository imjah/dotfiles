set nocompatible

" Plug:
" ------------------------------------------------------------------------------
fu! s:IsMissingPlugin()
	return len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
endfu

let s:dir=stdpath('data').'/plugged'
let s:src=stdpath('data').'/site/autoload/plug.vim'
let s:url='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if !filereadable(s:src)
	sil exe '!curl --create-dirs -fo' s:src s:url
endif

call plug#begin(s:dir)

Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf'
Plug 'kdheepak/lazygit.vim'
Plug 'sheerun/vim-polyglot'
Plug 'dense-analysis/ale'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'

call plug#end()

if (s:IsMissingPlugin())
	au VimEnter * PlugInstall --sync | so $MYVIMRC
	finish
endif

" Plugin: gruvbox
" ------------------------------------------------------------------------------
colorscheme gruvbox

" Plugin: fzf
" ------------------------------------------------------------------------------
nnoremap <silent> <Space> :FZF<CR>

" Plugin: lazygit
" ------------------------------------------------------------------------------
let g:lazygit_floating_window_scaling_factor = 1

nnoremap <silent> <C-Space> :LazyGit<CR>

" Plugin: commentary
" ------------------------------------------------------------------------------
nnoremap <silent> <C-c> :Commentary<CR>
vnoremap <silent> <C-c> :Commentary<CR>

" Plugin: tabular
" ------------------------------------------------------------------------------
vnoremap <C-t> :Tabularize /

" Editor:
" ------------------------------------------------------------------------------
set clipboard=unnamedplus " sync with system clipboard
set colorcolumn=81
set list                  " display invisible characters
set number                " display line numbers
set shortmess+=c          " hide completion message
set autoindent
set tabstop=4             " set hard tab width (when displays)
set softtabstop=4         " set hard tab width (when types)

nnoremap <silent> <C-h>   <C-w>h
nnoremap <silent> <C-j>   <C-w>j
nnoremap <silent> <C-k>   <C-w>k
nnoremap <silent> <C-l>   <C-w>l
nnoremap <silent> <C-q>   :q<CR>
nnoremap <silent> <C-s>   :w<CR>
nnoremap          <C-f>   :%s///g<Left><Left><Left>
vnoremap          <C-f>   :s///g<Left><Left><Left>
nnoremap <silent> <Enter> :!gnome-terminal<CR><Enter>
vnoremap <silent> <Space> :sort<CR>
inoremap <silent> <Tab>   <C-n>
