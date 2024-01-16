" nvim terminal
if has('nvim')
    tmap <silent> <m-C> <c-\><c-n>

    function! AweDeleteBuffer(bufnr)
        call timer_start(100, {_ -> execute('bdelete! ' . a:bufnr)})
    endfunction

    function! AweTerminalOpenSettings()
        setlocal nonumber
        map <buffer> <enter> i
        autocmd BufHidden <buffer> call AweDeleteBuffer(expand("<abuf>"))
        startinsert
    endfunction

    function! AweTerminalModeEnterSettings()
        NoMatchParen
        set nohlsearch
    endfunction

    function AweTerminalModeLeaveSettings()
        DoMatchParen
        set hlsearch
    endfunction

    augroup AweTerminal
        autocmd!
        autocmd TermOpen * call AweTerminalOpenSettings()
        autocmd TermEnter * call AweTerminalModeEnterSettings()
        autocmd TermLeave * call AweTerminalModeLeaveSettings()
    augroup END
endif
