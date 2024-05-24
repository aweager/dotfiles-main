" nvim terminal
if has('nvim')
    tmap <silent> <m-C> <c-\><c-n>

    function! AweDeleteBuffer(bufnr)
        call timer_start(100, {_ -> execute('bdelete! ' . a:bufnr)})
    endfunction

    function! TerminalOpenSettings()
        setlocal nonumber
        map <buffer> <enter> i
        autocmd BufHidden <buffer> call AweDeleteBuffer(expand("<abuf>"))
        startinsert
    endfunction

    function! TerminalModeEnterSettings()
        NoMatchParen
        set nohlsearch
    endfunction

    function TerminalModeLeaveSettings()
        DoMatchParen
        set hlsearch
    endfunction

    augroup AweTerminal
        autocmd!
        autocmd TermOpen * call TerminalOpenSettings()
        autocmd TermEnter * call TerminalModeEnterSettings()
        autocmd TermLeave * call TerminalModeLeaveSettings()
    augroup END
endif
