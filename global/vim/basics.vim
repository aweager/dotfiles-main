set foldmethod=syntax
set foldlevel=99
map zz za

" Text object for folds
vnoremap iz :<C-U>silent!normal![zjV]zk<CR>
onoremap iz :normal Vif<CR>
vnoremap az :<C-U>silent!normal![zV]z<CR>
onoremap az :normal Vaf<CR>

set cursorline

set expandtab
set tabstop=4
set shiftwidth=4
filetype indent on

syntax on

set number
set nofixeol
set nowrap
"set mouse=

highlight DiagnositHint ctermfg=darkgray guifg=darkgray
highlight DiagnositInfo ctermfg=darkgray guifg=darkgray

set laststatus=3
