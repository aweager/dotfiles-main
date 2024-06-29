if [[ -n "$NVIM" ]]; then
    () {
        local fifo=$(mktemp -u)
        mkfifo -m 600 "$fifo"
        nvr -cc ":lua require('init_d.terminal').write_zshrc_hook($$, '$fifo')"
        source "$fifo"
        rm "$fifo"
    }

    if [[ -z "$NVIM_BUFID" ]]; then
        export NVIM_BUFID="$(nvr --remote-expr "luaeval(\"require'init_d.terminal'.pid_to_bufnr($$)\")")"
    fi

    function _awe_vim_lcd_hook() {
        nvr -cc ":lua require'init_d.terminal'.lcd({
            buffer = $NVIM_BUFID,
            dir = \"$PWD\",
        })" &!
    }
    add-zsh-hook chpwd _awe_vim_lcd_hook
fi
