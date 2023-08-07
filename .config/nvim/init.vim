set nocompatible

" Plug:
" ----------------------------------------------------------------------------
fu! s:IsMissingPlugin()
	return len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
endfu

let s:dir = stdpath('data').'/plugged'
let s:src = stdpath('data').'/site/autoload/plug.vim'
let s:url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if !filereadable(s:src)
	sil exe '!curl --create-dirs -fo' s:src s:url
endif

call plug#begin(s:dir)

Plug 'ackyshake/VimCompletesMe'
Plug 'godlygeek/tabular'
Plug 'jiangmiao/auto-pairs'
Plug 'kdheepak/lazygit.vim'
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/syntastic'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'voldikss/vim-floaterm'

call plug#end()

if (s:IsMissingPlugin())
	au VimEnter * PlugInstall --sync | so $MYVIMRC
	finish
endif

" Plugin: floaterm
" ----------------------------------------------------------------------------
let g:floaterm_width         = 1.0
let g:floaterm_height        = 25
let g:floaterm_autoclose     = 2
let g:floaterm_position      = 'bottom'
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_next   = '<F6>'
let g:floaterm_keymap_prev   = '<F5>'
let g:floaterm_keymap_toggle = '<C-Space>'

" Plugin: gruvbox
" ----------------------------------------------------------------------------
colorscheme gruvbox

" Plugin: lazygit
" ----------------------------------------------------------------------------
let g:lazygit_floating_window_scaling_factor = 1

nnoremap <silent> <Space> :LazyGit<CR>

" Plugin: nerdtree
" ----------------------------------------------------------------------------
let NERDTreeBookmarksFile         = ''
let NERDTreeCascadeSingleChildDir = 0
let NERDTreeChDirMode             = 1
let NERDTreeDirArrowCollapsible   = ''
let NERDTreeDirArrowExpandable    = ''
let NERDTreeMinimalMenu           = 1
let NERDTreeMinimalUI             = 1
let NERDTreeShowHidden            = 1
let NERDTreeWinSize               = 35

nnoremap          <C-o> :NERDTree $REPOSITORIES_LOCAL/
nnoremap <silent> <C-\> :NERDTreeFocus<CR>
nnoremap <silent> \     :NERDTreeToggle<CR>

" Editor:
" ----------------------------------------------------------------------------
set clipboard=unnamedplus
set colorcolumn=+1
set list
set number
set shiftwidth=4
set shortmess+=c
set smartindent
set softtabstop=4
set splitbelow
set splitright
set tabstop=4
set title
set updatetime=500

nnoremap <C-f> :%s///g<Left><Left><Left>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-s> :w<CR>
nnoremap <silent> <F8> :!gnome-terminal<CR><Enter>
nnoremap <silent> <C-Up>    :resize +5<CR>
nnoremap <silent> <C-Down>  :resize -5<CR>
nnoremap <silent> <C-Left>  :vertical resize +5<CR>
nnoremap <silent> <C-Right> :vertical resize -5<CR>
tnoremap <C-q> <C-\><C-n>
vnoremap <silent> <Space> :sort<CR>
