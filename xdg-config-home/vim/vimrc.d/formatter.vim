"TODO move to fix.lua
if has('nvim')
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
