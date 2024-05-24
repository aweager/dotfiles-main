let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:python3_host_prog = 'python3'

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vimrc

lua vim.cmd('runtime! lua/config/*.lua')
