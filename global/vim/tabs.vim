" tab management

if exists('$USE_NTM')
    set showtabline=2

    highlight TabLine ctermbg=darkgray guibg=gray ctermfg=lightgray guifg=lightgray
    highlight TabLineItalic ctermbg=darkgray guibg=gray ctermfg=lightgray guifg=lightgray gui=italic cterm=italic

    highlight TabLineSel ctermfg=white guifg=white cterm=bold gui=bold
    highlight TabLineSelItalic ctermfg=white guifg=white cterm=bold,italic gui=bold,italic

    highlight TabLineFill ctermbg=darkcyan guibg=cyan ctermfg=darkcyan guifg=cyan

    " switching tabs
    map <silent> <m-h> gT
    imap <silent> <m-h> <esc>:call AweLastMode('i')<CR><m-h>
    vmap <silent> <m-h> <esc>:call AweLastMode('v')<CR><m-h>
    tmap <silent> <m-h> <c-\><c-n>:call AweLastMode('t')<CR><m-h>

    map <silent> <m-l> gt
    imap <silent> <m-l> <esc>:call AweLastMode('i')<CR><m-l>
    vmap <silent> <m-l> <esc>:call AweLastMode('v')<CR><m-l>
    tmap <silent> <m-l> <c-\><c-n>:call AweLastMode('t')<CR><m-l>

    " jumping between tabs
    map <silent> <m-0> :tabfirst<CR>
    imap <silent> <m-0> <esc>:call AweLastMode('i')<CR><m-0>
    vmap <silent> <m-0> <esc>:call AweLastMode('v')<CR><m-0>
    tmap <silent> <m-0> <c-\><c-n>:call AweLastMode('t')<CR><m-0>

    map <silent> <m-1> :tabnext 2<CR>
    imap <silent> <m-1> <esc>:call AweLastMode('i')<CR><m-1>
    vmap <silent> <m-1> <esc>:call AweLastMode('v')<CR><m-1>
    tmap <silent> <m-1> <c-\><c-n>:call AweLastMode('t')<CR><m-1>

    map <silent> <m-2> :tabnext 3<CR>
    imap <silent> <m-2> <esc>:call AweLastMode('i')<CR><m-2>
    vmap <silent> <m-2> <esc>:call AweLastMode('v')<CR><m-2>
    tmap <silent> <m-2> <c-\><c-n>:call AweLastMode('t')<CR><m-2>

    map <silent> <m-3> :tabnext 4<CR>
    imap <silent> <m-3> <esc>:call AweLastMode('i')<CR><m-3>
    vmap <silent> <m-3> <esc>:call AweLastMode('v')<CR><m-3>
    tmap <silent> <m-3> <c-\><c-n>:call AweLastMode('t')<CR><m-3>

    map <silent> <m-4> :tabnext 5<CR>
    imap <silent> <m-4> <esc>:call AweLastMode('i')<CR><m-4>
    vmap <silent> <m-4> <esc>:call AweLastMode('v')<CR><m-4>
    tmap <silent> <m-4> <c-\><c-n>:call AweLastMode('t')<CR><m-4>

    map <silent> <m-5> :tabnext 6<CR>
    imap <silent> <m-5> <esc>:call AweLastMode('i')<CR><m-5>
    vmap <silent> <m-5> <esc>:call AweLastMode('v')<CR><m-5>
    tmap <silent> <m-5> <c-\><c-n>:call AweLastMode('t')<CR><m-5>

    map <silent> <m-6> :tabnext 7<CR>
    imap <silent> <m-6> <esc>:call AweLastMode('i')<CR><m-6>
    vmap <silent> <m-6> <esc>:call AweLastMode('v')<CR><m-6>
    tmap <silent> <m-6> <c-\><c-n>:call AweLastMode('t')<CR><m-6>

    map <silent> <m-7> :tabnext 8<CR>
    imap <silent> <m-7> <esc>:call AweLastMode('i')<CR><m-7>
    vmap <silent> <m-7> <esc>:call AweLastMode('v')<CR><m-7>
    tmap <silent> <m-7> <c-\><c-n>:call AweLastMode('t')<CR><m-7>

    map <silent> <m-8> :tabnext 9<CR>
    imap <silent> <m-8> <esc>:call AweLastMode('i')<CR><m-8>
    vmap <silent> <m-8> <esc>:call AweLastMode('v')<CR><m-8>
    tmap <silent> <m-8> <c-\><c-n>:call AweLastMode('t')<CR><m-8>

    map <silent> <m-9> :tablast<CR>
    imap <silent> <m-9> <esc>:call AweLastMode('i')<CR><m-9>
    vmap <silent> <m-9> <esc>:call AweLastMode('v')<CR><m-9>
    tmap <silent> <m-9> <c-\><c-n>:call AweLastMode('t')<CR><m-9>

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
