set background=dark " Dark mode

set cmdheight=1 " Command window height 

set backspace=eol,start,indent " Backspace through newline characters

" Show line numbers
set ruler " Number to left of each line
set number " Line and column in bottom right corner

set showmatch " Show matching brackets

syntax enable " Syntax highlighting

set ai " Auto Indent

" Use spaces for tabs
set tabstop=4
set shiftwidth=4
set expandtab

" Line wrap
set wrap " Enable
set lbr " Line break on words

" KEYBINDS
" ESC => clear search highlighting
nnoremap <ESC> :nohlsearch<CR>

" CTRL + R => replace next search result
nnoremap <C-R> n.

" CTRL + A => open file as new tab
nnoremap <C-A> :tabfind 
inoremap <C-A> <ESC>:tabfind 
vnoremap <C-A> <ESC>:tabfind 

" Page Up => Go to end of line
nnoremap <PageUp> 0
inoremap <PageUp> <ESC>0i
vnoremap <PageUp> <ESC>0

" Page Down => Go to beginning of line
nnoremap <PageDown> $
inoremap <PageDown> <ESC>$a
vnoremap <PageDown> <ESC>$

" CTRL + S => Save
nnoremap <C-S> :w<CR>
inoremap <C-S> <ESC>:w<CR>a
vnoremap <C-S> <ESC>:w<CR>

" CTRL + Z/Y => Undo/Redo
nnoremap <C-Z> u
inoremap <C-Z> <ESC>ua
vnoremap <C-Z> <ESC>u

nnoremap <C-Y> :redo<CR>
inoremap <C-Y> <ESC>:redo<CR>i
vnoremap <C-Y> <ESC>:redo<CR>

" CTRL + C/X/V => Copy/Cut/Paste
nnoremap <C-C> "+yy
inoremap <C-C> <ESC>"+yyi
vnoremap <C-C> "+y

nnoremap <C-X> "+dd
inoremap <C-X> <ESC>"+ddi
vnoremap <C-X> "+d

nnoremap <C-V> "+p
inoremap <C-V> <ESC>"+pi
vnoremap <C-V> "+p

" CTRL + D => Duplicate current selection or line
nnoremap <C-D> yyp
inoremap <C-D> <ESC>yypi
vnoremap <C-D> yp

" CTRL + Up/Down => Move current selection or line
nnoremap <C-S-Up> ddkP
inoremap <C-S-Up> <ESC>ddkP

nnoremap <C-S-Down> ddjP
inoremap <C-S-Down> <ESC>ddjP

" CTRL + Space => Default autocomplete
inoremap <C-Space> <C-N>

" :AutoIndent => Auto indent document
command AutoIndent call feedkeys("gg=G")


