#!/bin/zsh

dumb clone aweager/jrpc
dumb clone aweager/mux-api
dumb clone aweager/tmux-mux
dumb clone aweager/nvim-mux

if [[ ! -d "$HOME/.local/venv" ]]; then
    if which python3.12 &> /dev/null; then
        python3.12 -m venv "$HOME/.local/venv"
    elif which python3.11 &> /dev/null; then
        python3.11 -m venv "$HOME/.local/venv"
    else
        printf '%s\n' 'Need at least python3.11 for venv' >&2
        return 1
    fi
fi

source "$HOME/.local/venv/bin/activate"

pip3 install -r "${0:a:h}/requirements.txt"
