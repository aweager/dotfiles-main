" if running in tmux (wither vertical or horizontal), rename the window
if !exists('$USE_NTM') && exists('$PMUX')
    augroup AwePmux
        autocmd!
        autocmd BufWinEnter * call jobstart("$AWE_CONFIG/global/zsh/fbin/rename_window \"" . expand("%:t") . "\" ")
    augroup END
endif
