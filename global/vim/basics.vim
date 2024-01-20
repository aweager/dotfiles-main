if has('nvim')
    set foldcolumn=auto:9
endif

set foldmethod=syntax
set foldlevel=99
map zz za

set cursorline

set expandtab
set tabstop=4
set shiftwidth=4
filetype indent on

syntax on

set number
set nofixeol
set nowrap
set mouse=

highlight DiagnositHint ctermfg=darkgray guifg=darkgray
highlight DiagnositInfo ctermfg=darkgray guifg=darkgray

set laststatus=3
