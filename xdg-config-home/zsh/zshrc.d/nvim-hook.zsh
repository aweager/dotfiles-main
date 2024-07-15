if [[ -n "$NVIM" && -z "$NVIM_TERMINAL_SESSION_LOADED" ]]; then
    () {
        local fifo=$(mktemp -u)
        mkfifo -m 600 "$fifo"
        nvr -cc ":lua require('init_d.terminal').write_zshrc_hook($$, '$fifo')"
        source "$fifo"
        rm "$fifo"
    }
    export NVIM_TERMINAL_SESSION_LOADED=1
fi
