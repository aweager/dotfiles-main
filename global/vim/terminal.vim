" nvim terminal
"if has('nvim')
"    tmap <silent> <m-C> <c-\><c-n>
"
"    function! AweTerminalModeEnterSettings()
"        if !exists('b:term_open_settings_loaded')
"            call AweTerminalOpenSettings()
"        endif
"
"        NoMatchParen
"        set nohlsearch
"    endfunction
"
"    function AweTerminalModeLeaveSettings()
"        DoMatchParen
"        set hlsearch
"    endfunction
"
"    augroup AweTerminal
"        autocmd!
"        autocmd TermOpen * call AweTerminalOpenSettings()
"        autocmd TermEnter * call AweTerminalModeEnterSettings()
"        autocmd TermLeave * call AweTerminalModeLeaveSettings()
"    augroup END
"endif
