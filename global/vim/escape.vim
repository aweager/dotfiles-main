imap jk <ESC>

nmap <m-[> <ESC>
imap <m-[> <ESC>
vmap <m-[> <ESC>
cmap <m-[> <ESC>
omap <m-[> <ESC>
tmap <m-[> <ESC>

" For Vortex Cypher, which has no dedicated ` key
function! VortexCypherMap()
    nmap `` <ESC>
    imap `` <ESC>
    vmap `` <ESC>
    cmap `` <ESC>
    omap `` <ESC>
    tmap `` <ESC>
endfunction

function! VortexCypherUnmap()
    nunmap ``
    iunmap ``
    vunmap ``
    cunmap ``
    ounmap ``
    tunmap ``
endfunction

command VortexCypherMap call VortexCypherMap()
command VortexCypherUnmap call VortexCypherUnmap()
