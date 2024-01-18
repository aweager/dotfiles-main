" shada and sessions

if has('nvim')
    set shada='0,/0,:0,<1000,@0,f0,s10,h
    augroup AweShada
        autocmd!
        autocmd TextYankPost * wshada
        autocmd User AweFocusIn rshada
    augroup END
endif

if exists('$USE_NTM')
    set sessionoptions=blank,curdir,folds,help,tabpages,winsize,terminal
    let g:session_file=$HOME . '/.cache/nvim/sessions/' . $NEOVIM_SESSION_GROUP . getcwd() . '.vim'
    if filereadable(g:session_file)
        execute 'source' g:session_file
    endif

    function! AweWriteSession()
        call system('mkdir -p ' . fnamemodify(g:session_file, ':h'))
        execute 'mksession!' g:session_file
    endfunction

    augroup AweSessions
        autocmd!
        autocmd VimLeave * call AweWriteSession()
    augroup END
endif
