""""Fuzzy search
let g:root_dir=getcwd()

"TODO: should this be OS-specific?
set rtp+=/opt/homebrew/opt/fzf

"TODO: save mode...?

"File names
map <silent> <m-p> :execute 'Files' g:root_dir<enter>
imap <silent> <m-p> <esc><m-p>
vmap <silent> <m-p> <esc><m-p>
tmap <silent> <m-p> <C-\><C-n><m-p>

"File names of git files
map <silent> <m-g> :execute 'GFiles' g:root_dir<enter>
imap <silent> <m-g> <esc><m-g>
vmap <silent> <m-g> <esc><m-g>
tmap <silent> <m-g> <C-\><C-n><m-g>

"File contents
map <silent> <m-f> :call fzf#vim#ag('', {'dir': g:root_dir})<enter>
imap <silent> <m-f> <esc><m-f>
vmap <silent> <m-f> <esc><m-f>
tmap <silent> <m-f> <C-\><C-n><m-f>

""""Buffer management

"Cycle thru buffers
map <silent> <C-p> :BufferHistoryBack<enter>
map <silent> <C-n> :BufferHistoryForward<enter>

"Move current buffer into its own tab
map <silent> <leader>p :tabnew %<enter>

"Copy path to the current buffer, relative to root
map <silent> <m-C> :let @+ = substitute(expand('%:p'), '^' . g:root_dir . '/', '', '')<CR>
