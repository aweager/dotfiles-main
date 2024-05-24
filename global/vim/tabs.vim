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
    imap <silent> <m-h> <esc>:call AweLastMode('i')<CR><m-h>
    vmap <silent> <m-h> <esc>:call AweLastMode('v')<CR><m-h>
    tmap <silent> <m-h> <c-\><c-n>:call AweLastMode('t')<CR><m-h>

    map <silent> <m-l> gt
    imap <silent> <m-l> <esc>:call AweLastMode('i')<CR><m-l>
    vmap <silent> <m-l> <esc>:call AweLastMode('v')<CR><m-l>
    tmap <silent> <m-l> <c-\><c-n>:call AweLastMode('t')<CR><m-l>

    " arranging tabs
    map <silent> <m-H> :tabm -1<CR>
    imap <silent> <m-H> <c-o><m-H>
    vmap <silent> <m-H> <esc><m-H>gv
    tmap <silent> <m-H> <c-\><c-n><m-H>a

    map <silent> <m-L> :tabm +1<CR>
    imap <silent> <m-L> <c-o><m-L>
    vmap <silent> <m-L> <esc><m-L>gv
    tmap <silent> <m-L> <c-\><c-n><m-L>a

    " opening / closing tabs
    map <silent> <m-t> :tabnew \| terminal<CR>
    imap <silent> <m-t> <esc>:call AweLastMode('i')<CR><m-t>
    vmap <silent> <m-t> <esc>:call AweLastMode('v')<CR><m-t>
    tmap <silent> <m-t> <c-\><c-n>:call AweLastMode('t')<CR><m-t>

    map <silent> <m-w> :call AweCloseTab()<CR>
    imap <silent> <m-w> <esc><m-w>
    vmap <silent> <m-w> <esc><m-w>
    tmap <silent> <m-w> <c-\><c-n><m-w>

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
            let b:last_mode='call AweStartinsertAfter()'
        elseif a:last_mode == 'v'
            let b:last_mode='norm gv'
        else
            unlet b:last_mode
        endif
    endfunction

    function! AweStartinsertAfter()
        if col('.') == col('$') - 1
            startinsert!
        else
            normal l
            startinsert
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
