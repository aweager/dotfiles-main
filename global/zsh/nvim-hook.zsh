() {
    if [[ -n "$NVIM" ]]; then
        local fifo=$(mktemp -u)
        mkfifo -m 600 "$fifo"
        nvr -cc ":lua require('terminal').write_zshrc_hook($$, '$fifo')"
        source "$fifo"
        rm "$fifo"
    fi
}
