if has('nvim')
    nnoremap <silent> <leader>f :Format<enter>
    nnoremap <silent> <leader>F :FormatWrite<enter>

    nnoremap <silent> <leader>l :lua require('lint').try_lint()<enter>

    function! AweLintAndFormat()
        lua require('lint').try_lint()
        FormatLock
    endfunction

    augroup AweFormat
        autocmd!
        autocmd BufWritePost * call AweLintAndFormat()
        autocmd User FormatterPost update!
    augroup END
endif
