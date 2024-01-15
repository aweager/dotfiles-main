" tab management

if exists('$USE_NTM')
    set showtabline=2

    highlight TabLine ctermbg=darkgray guibg=darkgray ctermfg=lightgray guifg=lightgray
    highlight TabLineItalic ctermbg=darkgray guibg=darkgray ctermfg=lightgray guifg=lightgray gui=italic cterm=italic

    highlight TabLineSel ctermfg=white guifg=white cterm=bold gui=bold
    highlight TabLineSelItalic ctermfg=white guifg=white cterm=bold,italic gui=bold,italic

    highlight TabLineFill ctermbg=darkcyan guibg=darkcyan ctermfg=darkcyan guifg=darkcyan

    " switching tabs
    map <silent> <m-h> gT
    map <silent> <m-l> gt
    imap <silent> <m-h> <esc>:call AweLastMode('i')<enter><m-h>
    imap <silent> <m-l> <esc>:call AweLastMode('i')<enter><m-l>
    vmap <silent> <m-h> <esc>:call AweLastMode('v')<enter><m-h>
    vmap <silent> <m-l> <esc>:call AweLastMode('v')<enter><m-l>
    tmap <silent> <m-h> <c-\><c-n>:call AweLastMode('t')<enter><m-h>
    tmap <silent> <m-l> <c-\><c-n>:call AweLastMode('t')<enter><m-l>

    " arranging tabs
    map <silent> <m-H> :tabm -1<enter>
    map <silent> <m-L> :tabm +1<enter>
    imap <silent> <m-H> <esc>:call AweLastMode('i')<enter><m-H>
    imap <silent> <m-L> <esc>:call AweLastMode('i')<enter><m-L>
    vmap <silent> <m-H> <esc>:call AweLastMode('v')<enter><m-H>
    vmap <m-L> <esc>:call AweLastMode('v')<enter><m-L>
    tmap <silent> <m-H> <c-\><c-n>:call AweLastMode('t')<enter><m-H>
    tmap <silent> <m-L> <c-\><c-n>:call AweLastMode('t')<enter><m-L>

    " opening / closing tabs
    map <silent> <m-t> :tabnew \| terminal<enter>
    imap <silent> <m-t> <esc>:call AweLastMode('i')<enter><m-t>
    vmap <silent> <m-t> <esc>:call AweLastMode('v')<enter><m-t>
    tmap <silent> <m-t> <c-\><c-n>:call AweLastMode('t')<enter><m-t>

    map <silent> <m-w> :call AweCloseTab()<enter>
    imap <silent> <m-w> <esc>:call AweLastMode('t')<enter><m-w>
    vmap <silent> <m-w> <esc>:call AweLastMode('t')<enter><m-w>
    tmap <silent> <m-w> <c-\><c-n>:call AweLastMode('t')<enter><m-w>

    function! AweCloseTab()
        if len(nvim_list_tabpages()) == 1
            quitall!
        else
            tabclose
        endif
    endfunction

    "TODO: autocmd setup to not have to put this manually in shortcuts?
    function! AweLastMode(last_mode)
        if a:last_mode == 'i' || a:last_mode == 't'
            let b:last_mode='startinsert \| norm l'
        elseif a:last_mode == 'v'
            let b:last_mode='norm gv'
        else
            unlet b:last_mode
        endif
    endfunction

    function! AweRestoreMode()
        if exists("b:last_mode")
            execute(b:last_mode)
            unlet b:last_mode
        endif
    endfunction

    augroup AweModes
        autocmd!
        autocmd BufEnter * call AweRestoreMode()
    augroup END
endif
