let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vimrc

"TODO: glob this
lua require('config/local')
lua require('config/lsp')
lua require('config/cmp')
lua require('config/status')
lua require('config/tabs')
lua require('config/formatter')
"lua require('config/tree')
