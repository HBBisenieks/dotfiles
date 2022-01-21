filetype plugin on
filetype indent on

set autoread

set ruler
set number
set relativenumber

set cmdheight=2

set lazyredraw

syntax enable

set smarttab
set ai
set si
set wrap

set backspace=indent,eol,start

""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

call plug#begin()

Plug 'pearofducks/ansible-vim'
Plug 'vimwiki/vimwiki'

call plug#end()
