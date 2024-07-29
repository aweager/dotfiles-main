#!/bin/zsh

dumb clone aweager/jrpc

if [[ ! -d "$HOME/.local/venv" ]]; then
    python3.12 -m venv "$HOME/.local/venv"
fi

source "$HOME/.local/venv/bin/activate"

pip3 install -r "${0:a:h}/requirements.txt"
